From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 0/1] RFC: Use /dev/md/X as default name
Date: Wed, 18 Feb 2015 17:11:33 -0500
Message-ID: <wrfj61ay6fai.fsf@redhat.com>
References: <1423684389-10977-1-git-send-email-Jes.Sorensen@redhat.com>
	<wrfjsie36qdi.fsf@redhat.com> <20150219083708.2ab46006@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150219083708.2ab46006@notabene.brown> (NeilBrown's message of
	"Thu, 19 Feb 2015 08:37:08 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Wed, 18 Feb 2015 13:12:09 -0500 Jes Sorensen <Jes.Sorensen@redhat.com>
> wrote:
>
>> Jes.Sorensen@redhat.com writes:
>> > From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> >
>> > I have received some issues for when creating an array using a
>> > /dev/mdX name, the matching symlink in /dev/md/X isn't
>> > created. Whereas if you create /dev/md/X, /dev/mdX is created
>> > automatically.
>> >
>> > I was trying to see if there was a better way of dealing with this,
>> > but I couldn't find one. If you have suggestions for a better solution
>> > I am all ears.
>> >
>> > Thoughts?
>> 
>> Hi Neil,
>> 
>> Any thoughts on this one?
>
> Thanks for the reminder....
>
> I'm not sure that I really see the problem.
>
>   "I ask it to create /dev/mdX and it doesn't create /dev/md/X".
>
> Well ... no.  You didn't ask it to.  If you want it to create /dev/md/X,
> then ... ask it to.
>
> /dev/mdX is the canonical name.  It always gets created.
> /dev/md/X is a convenient alias.  It gets created if requested.
>
> Is there really a problem here worth solving?
>
> Maybe I missed something.

I have had complaints in Fedora from the installer people that they rely
on the /dev/md/ name being created when they create a new device. It is
also inconsistent because /dev/md/<X> will be created if you run
'mdadm -As' later on.

I don't see it as a major issue, but I can see why it is frustrating for
some and I think there is something to be said for being consistent in
behavior.

Cheers,
Jes

