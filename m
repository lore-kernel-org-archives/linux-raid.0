From: Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: Re: [PATCH] debian: symlink mdmon pidfile into /run/sendsigs.omit.d
Date: Mon, 03 Sep 2012 16:50:37 +0200
Message-ID: <5044C3BD.7060307@xs4all.net>
References: <50375007.5070401@xs4all.net> <CANBHLUgG49s1aiiKnxQTCDUF861wHv=2N+w73_7K-bi3tyysOg@mail.gmail.com> <50376A60.2010104@xs4all.net> <20120824223152.527e1ced@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120824223152.527e1ced@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Dmitrijs Ledkovs <xnox@debian.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24-08-12 2:31 PM, NeilBrown wrote:
> On Fri, 24 Aug 2012 13:49:52 +0200 Miquel van Smoorenburg <mikevs@xs4all.net>
> wrote:
>
>> On 24-08-12 1:12 PM, Dmitrijs Ledkovs wrote:
>>> On 24 August 2012 10:57, Miquel van Smoorenburg <mikevs@xs4all.net> wrote:
>>>> Some daemons should not be killed when the system is shutting down. In
>>>> debian this is achieved by putting a file with the pid of the daemon in it
>>>> in /run/sendsigs.omit.d (or a symlink to its pidfile).
>>>>
>>>> This patch lets mdmon automatically create a symlink in /run/sendsigs.omit.d
>>>> to its pidfile.
>
> However if we only need to protect things at shutdown I wonder it you could
> just add something like:
>
>   cd /run/mdadm/
>   for file in md*.pid
>   do ln -s /run/mdadm/$file /.../sendsigs.omit.d/mdadm-$file
>   done
>
> in some script that gets run before the 'killall' happens.

Yes that would work. Very good idea!

Forget about the patch. I'll just add something like that to the stop 
section of the mdadm-raid initscript.

Thanks!

Mike.
