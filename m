From: mark delfman <markdelfman@googlemail.com>
Subject: Re: raid0 failures
Date: Fri, 2 Oct 2009 14:10:31 +0100
Message-ID: <66781b10910020610m61ccc3d6p54ca22fb19b5f0c1@mail.gmail.com>
References: <5d96567b0910010731t513a84a5m1f85e715a69efab6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0910010731t513a84a5m1f85e715a69efab6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Raz <raziebe@gmail.com>
Cc: Neil Brown <neilb@suse.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

very sorry, i am not sure how to link to my previous post on this
(25/09) so pasted it again below.... hopefully Neil this offers some
situations (and growing solutions) which would very much benefit from
this


Hi All...

MD today is out performing many mid-level and above hardware raids and
as such becoming more of a widely used tool.  So although I can see
that this topic or =91hiccup=92 has been discussed a few times, I cant
find a resolution or decision.

Basically, there seems no way to tell a RAID0 error... I Know that it
may seem obvious (your /dev/xxx dies), but as I say MD nowadays is
presented to systems in all sorts of ways (i.e. MD > LVM > XFS > IET
etc).  so the user may not even familiar with the MD or isolated...
MDadm monitors all other raids well allowing messages to be emailed etc=
,.

I think it would be good if MDadm could report  a R0 in any basic way..=
=2E.

I am new to linux, so thought that I best define what I am doing /
seeing in case I am just being stupid....

(mdadm ver 3.0)

If drive fails on RAID0 then mdadm reports the array with faulty drive
as =93Active=94

1)	When I monitor the md device

Mdadm =96monitor /dev/mdx

I get the message =93DeviceDisappeared on /dev/mdx Wrong-Level=94

I seem to get this message even when md device is in good state and
not just when I have failed disk

The previous thread that I read seemed to imply that this message is
only on failed device status and on reading manual that is what I was
expecting.

Have  I misunderstood the manual?


If above is not the case then is there any effective way to monitor
for RAID0 failure. I understand that md cannot do anything about
failed disk, but it would be useful to know of md device failure
before an application IO request.


Although md can do nothing about RAID0 failure there are layers
sitting on top that are constantly dependent on knowing status of md
device



On Thu, Oct 1, 2009 at 3:31 PM, Raz <raziebe@gmail.com> wrote:
> Neil Hello
> I have noticed that raid0 cannot tell if an IO to a had disk failed o=
r
> not. This is a problem in some cases because i need the raid to stop.
> I am thinking of fixing it. what is the best approach if any you
> believe is possible ?
> thank you
> raz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
