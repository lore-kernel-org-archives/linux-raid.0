From: "Joe Landman" <joe.landman@gmail.com>
Subject: Re: question on how to (correctly) build an initrd for a root disk on a RAID1
Date: Mon, 27 Oct 2008 14:02:47 -0400
Message-ID: <9f5edc120810271102j74f7e130neaa54b90195ac4d5@mail.gmail.com>
References: <9f5edc120810261937w339f2919p4f7ce82fbcaf2149@mail.gmail.com>
	 <20081027071613.GA8197@maude.comedia.it>
	 <9f5edc120810270534j3d969d2s18c1017755990c30@mail.gmail.com>
	 <4905EE05.9070108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4905EE05.9070108@redhat.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Brendan Conoboy <blc@redhat.com>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Oct 27, 2008 at 12:36 PM, Brendan Conoboy <blc@redhat.com> wrote:
> Joe Landman wrote:
>>
>> Ok.  This is where it gets interesting.  If the /etc/mdadm.conf is on
>> the RAID, you have a bit of a "chicken and egg" problem to deal with
>> here.  How does the system find /etc/mdadm.conf to make the RAID when
>> /etc/mdadm.conf is on the RAID?
>>
>> This implies that /etc/mdadm.conf is in the initrd.  Peeking inside
>> the default centos one, I can see that this is not true.  Which
>> implies that it doesn't see /etc/mdadm.conf before it assembles the
>> array, as the /etc/mdadm.conf is on the array, and not in the initrd
>> image.
>>
>> Is there a way to include the /etc/mdadm.conf into the initrd?
>
> This is almost certainly your problem.  If / is a RAID volume, the initrd
> itself needs to have an /etc/mdadm.conf that reflects how it is constructed.

Hmmm... there was no mdadm.conf even in the centos initrd.  I'll see
if I can force this to be the case.

Since I didn't see the mdadm.conf in the initrd, I assumed it was
autoassembling.  Though it was
my understanding that this is a "bad" thing.

>  This is something that mkinitrd should be doing for you. I'll second the
> suggestion of running mkinitrd with sh's -x option to see why it's not doing
> this for you.  Good luck.

I think I need to dig into the resulting initrd more.   Compare it to
the initrd from the default install.
I did this before, but now I think we need to do this with greater diligence.
