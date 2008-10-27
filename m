From: Brendan Conoboy <blc@redhat.com>
Subject: Re: question on how to (correctly) build an initrd for a root disk
 on a RAID1
Date: Mon, 27 Oct 2008 10:36:21 -0600
Message-ID: <4905EE05.9070108@redhat.com>
References: <9f5edc120810261937w339f2919p4f7ce82fbcaf2149@mail.gmail.com>	 <20081027071613.GA8197@maude.comedia.it> <9f5edc120810270534j3d969d2s18c1017755990c30@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9f5edc120810270534j3d969d2s18c1017755990c30@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Joe Landman wrote:
> Ok.  This is where it gets interesting.  If the /etc/mdadm.conf is on
> the RAID, you have a bit of a "chicken and egg" problem to deal with
> here.  How does the system find /etc/mdadm.conf to make the RAID when
> /etc/mdadm.conf is on the RAID?
> 
> This implies that /etc/mdadm.conf is in the initrd.  Peeking inside
> the default centos one, I can see that this is not true.  Which
> implies that it doesn't see /etc/mdadm.conf before it assembles the
> array, as the /etc/mdadm.conf is on the array, and not in the initrd
> image.
> 
> Is there a way to include the /etc/mdadm.conf into the initrd?

This is almost certainly your problem.  If / is a RAID volume, the 
initrd itself needs to have an /etc/mdadm.conf that reflects how it is 
constructed.  This is something that mkinitrd should be doing for you. 
I'll second the suggestion of running mkinitrd with sh's -x option to 
see why it's not doing this for you.  Good luck.

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
