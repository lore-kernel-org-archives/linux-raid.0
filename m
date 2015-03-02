From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 0/1] RFC: Use /dev/md/X as default name
Date: Mon, 02 Mar 2015 11:32:16 -0500
Message-ID: <wrfjoaobz7fz.fsf@redhat.com>
References: <1423684389-10977-1-git-send-email-Jes.Sorensen@redhat.com>
	<wrfjsie36qdi.fsf@redhat.com> <20150219083708.2ab46006@notabene.brown>
	<wrfj61ay6fai.fsf@redhat.com> <20150219093236.25660678@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150219093236.25660678@notabene.brown> (NeilBrown's message of
	"Thu, 19 Feb 2015 09:32:36 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Wed, 18 Feb 2015 17:11:33 -0500 Jes Sorensen <Jes.Sorensen@redhat.com>
> wrote:
>
>> NeilBrown <neilb@suse.de> writes:
>> > On Wed, 18 Feb 2015 13:12:09 -0500 Jes Sorensen <Jes.Sorensen@redhat.com>
>> > wrote:
>> >
>> >> Jes.Sorensen@redhat.com writes:
>> >> > From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> >> >
>> >> > I have received some issues for when creating an array using a
>> >> > /dev/mdX name, the matching symlink in /dev/md/X isn't
>> >> > created. Whereas if you create /dev/md/X, /dev/mdX is created
>> >> > automatically.
>> >> >
>> >> > I was trying to see if there was a better way of dealing with this,
>> >> > but I couldn't find one. If you have suggestions for a better solution
>> >> > I am all ears.
>> >> >
>> >> > Thoughts?
>> >> 
>> >> Hi Neil,
>> >> 
>> >> Any thoughts on this one?
>> >
>> > Thanks for the reminder....
>> >
>> > I'm not sure that I really see the problem.
>> >
>> >   "I ask it to create /dev/mdX and it doesn't create /dev/md/X".
>> >
>> > Well ... no.  You didn't ask it to.  If you want it to create /dev/md/X,
>> > then ... ask it to.
>> >
>> > /dev/mdX is the canonical name.  It always gets created.
>> > /dev/md/X is a convenient alias.  It gets created if requested.
>> >
>> > Is there really a problem here worth solving?
>> >
>> > Maybe I missed something.
>> 
>> I have had complaints in Fedora from the installer people that they rely
>> on the /dev/md/ name being created when they create a new device. It is
>> also inconsistent because /dev/md/<X> will be created if you run
>> 'mdadm -As' later on.
>
> If they rely on the /dev/md/ name being created, then surely they should ask
> for it to be created.
> Is it really harder to run "mdadm -C /dev/md/0" than "mdadm -C /dev/md0" ??
>
> If you create an array as "/dev/md0", then after subsequent "mdadm
> -As" /dev/md0 will exist.
> If you create an array as "/dev/md/0", then after subsequent mdadm
> -As", /dev/md/0 will exist.
>
> The fact that something unasked for also exists is a bonus.
>
>> 
>> I don't see it as a major issue, but I can see why it is frustrating for
>> some and I think there is something to be said for being consistent in
>> behavior.
>
> I think the behaviour is perfectly consistent.  It just follows rules that
> are slightly less trivial that some people appear to want.
>
> However....
> If you changed
>
> 			mp = map_by_uuid(&map, info->uuid);
> 			if (mp && mp->path &&
> 			    strncmp(mp->path, "/dev/md/", 8) == 0) {
> 				printf("MD_DEVNAME=");
> 				print_escape(mp->path+8);
> 				putchar('\n');
> 			}
>
>
> in Detail.c so that when mp->path were "/dev/md0", MD_DEVNAME became "0",
> then you should get the result that you are after, and I probably wouldn't
> object to the patch.

Neil,

Finally had time to go back and look at this - I don't quite understand
your request here.

As far as I can see, the above code isn't run at all during device
creation, so I don't get how modifying it as you suggest will make
/dev/md/111 appear if I create /dev/md111?

Cheers,
Jes
