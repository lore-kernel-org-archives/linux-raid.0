From: Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: Re: [PATCH] debian: symlink mdmon pidfile into /run/sendsigs.omit.d
Date: Fri, 24 Aug 2012 13:49:52 +0200
Message-ID: <50376A60.2010104@xs4all.net>
References: <50375007.5070401@xs4all.net> <CANBHLUgG49s1aiiKnxQTCDUF861wHv=2N+w73_7K-bi3tyysOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANBHLUgG49s1aiiKnxQTCDUF861wHv=2N+w73_7K-bi3tyysOg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dmitrijs Ledkovs <xnox@debian.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24-08-12 1:12 PM, Dmitrijs Ledkovs wrote:
> On 24 August 2012 10:57, Miquel van Smoorenburg <mikevs@xs4all.net> wrote:
>> Some daemons should not be killed when the system is shutting down. In
>> debian this is achieved by putting a file with the pid of the daemon in it
>> in /run/sendsigs.omit.d (or a symlink to its pidfile).
>>
>> This patch lets mdmon automatically create a symlink in /run/sendsigs.omit.d
>> to its pidfile.
>>
>> See also debian bug 684708 at
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=684708  ,
>> where I submitted a previous version of this patch.
>>
>> Comments welcome.
>>
>
> For upstream, it might be more appropriate to have a configurable
> MDMON_PIDDIR, which defaults to $MDMON_DIR. As far as I know,
> sendssigs.omit.d is very specific to Debian and it's derivatives, and
> it's not used in the brave new systemd world.

Well, I'm not sure if there's a guideline for this in debian, but the 
convention appears to be to put the pidfiles in /run or a 
package-specific subdir of /run, and then to create a symlink from the 
sendsigs.omit.d directory to the pidfile- which is exactly what this 
patch does. If you're saying that something debian-specific like this 
should not be in the upstream package, then that's fine, and the patch 
will just be carried in debian. No problem.

Note that I am not the debian mdadm maintainer, it's just that often 
it's appreciated if a bug/patch submitter works with upstream.

Thanks,

Mike.
