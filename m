From: Martin Wilck <mwilck@arcor.de>
Subject: Re: DDF test fails if default udev rules are active
Date: Tue, 06 Aug 2013 23:44:37 +0200
Message-ID: <52016E45.8000108@arcor.de>
References: <51535A25.1040501@arcor.de> <20130424161348.1f7e3abc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130424161348.1f7e3abc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/24/2013 08:13 AM, NeilBrown wrote:
> On Wed, 27 Mar 2013 21:44:21 +0100 Martin Wilck <mwilck@arcor.de> wrote:
> 
>> Hi Neil,
>>
>> with my latest patch set, the DDF test case (10-ddf-create) succeeds
>> reliably for me, with one caveat: It works only if I disable the rule
>> that runs "mdadm -I" on a newly discovered container. On my system
>> (Centos 6.3) it is in /lib/udev/65-md-incremental.rules, and the rule is
>>
>> SUBSYSTEM="block", ACTION="add|change", KERNEL="md*", \
>>   ENV{MD_LEVEL}=="container", RUN+="/sbin/mdadm -I $env{DEVNAME}"
>>
>> The reason is that the DDF test case runs mdadm -Asc after writing the
>> conf file defining the container and 3 arrays.
>>
>> mdadm -Asc will first create the container. When it starts tries to
>> create the member arrays, these have already been started by the udev
>> rule above, causing the assembly to fail with the error message "member
>> /dev/md127/1 in /dev/md127 is already assembled".
>>
>> I have done my testing with the above udev rule commented out, and all
>> goes fine. But I am not sure if "mdadm -Asc /var/tmp/mdadm.conf" failing
>> indicates a problem with the DDF code, or if it's really just a problem
>> with the test case. Personally, I'd rather have a test case that
>> succeeds by default on a system with standard configuration (which means
>> the above udev rule should be active).
>>
>> What do you think?
>> Martin
> 
> Hi Martin,
>  I think this is a real issue that has occasionally annoyed me a bit but
>  never enough to make me seriously address it - so thanks for raising it.
> 
>  I generally would like the tests to run without any interference from udev,
>  though I certainly see the value of testing in a "standard config" context
>  too.
> 
>  Fortunately it appears to be easy to address.
>    udevadm control --stop-exec-queue
>  will pause udev, and
>    udevadm control --start-exec-queue
>  will cause udev to resume.
> 
>  So I suggest that we change the 'test' script to run:
> 
>     udevadm settle; udevadm control --stop-exec-queue
> 
>  before running each test script, and
> 
>     udevadm control --start-exec-queue
> 
>  after the script.
>  Then if a script wants to run in "standard" context, it could simply put
>     udevadm control --start-exec-queue
>  at the top.  The default would be to disable udev which is what most scripts
>  expect.
> 
>  Can you try that?

It took me a while. I just tried today. Unfortunately it doesn't work
right, at least not on CentOS 6. With the exec 	queue stopped, the
container devices /dev/md/xyz won't be created in the first place
("timeout waiting for /dev/md/ddf"). I also tried additionally
MDADM_NO_UDEV=1, but that would cause even other problems. I didn't dig
any deeper. Disabling that single rule works fine for me.

Martin
