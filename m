From: sfunk1x <sfunk1x@gmail.com>
Subject: Re: MDADM RAID 6 Bad Superblock after reboot
Date: Wed, 18 Oct 2017 18:52:22 -0700
Message-ID: <63c30fde-d2df-bb92-d6c9-d231a955b5ce@gmail.com>
References: <6a0f0e0b-6b03-8ec1-b02f-b17b0447aff8@gmail.com>
 <AA5FDF15-8966-4793-9215-2814C1A6848D@gmail.com>
 <59E7AE4B.5000903@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59E7AE4B.5000903@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/18/2017 12:40 PM, Wols Lists wrote:
> What does --detail tell us about the array?

https://imgur.com/a/Own0W

Apologies for the imgur link, but this was the easiest way to
communicate --detail.

> Are you sure the three drives were added? SELinux has a habit of causing
> havoc. Did the available space on the array increase? Did you check?

Yeah. The array took about 17 hours to rebuild with the three drives
added (I had expected over 24 as that had been my experience with adding
the 5th drive long ago), and I had immediately started using the extra
space. The extra 8+ TB showed up in --details, as well as df, and my
guests could see the extra space.

The SELinux audit log, however, was very clear about mdadm not being
able to edit the conf. And it's true - the conf file did not have the
extra drives added. I've since audited and applied a rule to allow the
editing of the conf file, but the system is currently in permissive mode
until the array is back online. I can disable if needed.

> Firstly, make sure SELinux didn't interfere with the grow. My guess is
> the add failed because SELinux blocked it, and in reality you've still
> got a five-drive array, it just thinks it's an eight-drive array, so
> when the system rebooted it said "five drives of eight? Not enough!" and
> stopped.

I could see this being the case - on reboot, the configuration would
specify 5 drives instead of the 8. In addition, the system did not get
rebooted after the array had been grown - I just kept it running and put
it to work. Lesson learned.

> If I'm right, recovery is hopefully a simple matter of disabling
> SELinux, and re-assembling the array with either reverting the grow, or
> firing it off so it can actually run and complete.


Thanks for the vote of confidence in not losing data here. As I
mentioned above, I've set SELinux into permissive mode. I'm sort of at a
loss as to what to do next. Since sd[fgh] don't have any superblock
data, can I try to bring the array back online with 5 drives, then
re-add the last three, with the hope that they sync? There obviously
hasn't been any writes to the last three drives since the hard system
reboot, so I'd hope their event numbers would be in sync?

Thanks,

-Sean
