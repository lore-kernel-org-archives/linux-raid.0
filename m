From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Fri, 2 Oct 2009 09:51:41 +0200
Message-ID: <20091002075141.GB2781@rap.rap.dk>
References: <babafd2f0910011827l2bc62facpc5fe15ab3994b512@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <babafd2f0910011827l2bc62facpc5fe15ab3994b512@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ben DJ <bendj095124367913213465@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 01, 2009 at 06:27:57PM -0700, Ben DJ wrote:
> I'm setting up new linux boxes, hoping to install whatever OS I choose
> to a software RAID array.
> 
> I've got 4 identical SATA drives, and would ideally like to use RAID-10.
> 
> I've read a bunch of slightly stale How-To docs, and have a few questions.
> 
> (1) Can Linux boot from /boot on RAID-10?  Oldest info I found said no
> boot from RAID at all, then more recent docs said boot from RAID-1
> works.  I found nothing on RAID-10.  What's the latest sccop on this?

You can boot from a raid-10,n2 with the superblock last, standard
raid10,n2 will do. But the normal thing is to boot from raid-1

There is a description of a setup at 
http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_disk

> (2) As far as I can tell, none of the installers in Centos, Ubuntu or
> Opensuse are RAID-10 aware.  Seems like the sanest way to get setup
> would be to boot from SystemRescueCD, do the partitioning and RAID
> creation, then re-boot from an installer disk using the pre-setup
> disks.

I have set up centos systems using the above guide.

best regards
keld
