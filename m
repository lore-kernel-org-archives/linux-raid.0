From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Software RAID-1: step-by-step help needed...
Date: Tue, 10 Aug 2004 09:53:59 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0408100948230.1665@lion.drogon.net>
References: <41188A95.5000608@provincia.verbania.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41188A95.5000608@provincia.verbania.it>
To: Boniforti Flavio <boniforti@provincia.verbania.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 10 Aug 2004, Boniforti Flavio wrote:

> Hello all!
> I'm a pure newbie in facts of RAID on Linux, therefore I'd like to get
> some help and some explanations about RAID-1 (Software-RAID) onto a
> Linux server I have to configure.
> How should I proceed to get my RAID-1 set up and working?
> Are there known issues about the booting process on RAID?
> Do I have to "mirror" each single partition or is it possible to
> "mirror" the whole disk?

You can do either. Personally, I create identical partitions on each drive
and then mirror them.

Probably the easiest way to get started is to pick a distribution that
lets you build the disks as a mirror from install time - Eg. Red Hat (or
whatever it's called these days) If you have an existing server with one
disk and want to add a 2nd as a mirror, thats not too difficult. you need
to read the stuff in the Software RADI HowTo which has the information on
how to do it all.

Booting RAID1 with Lilo is easy, I presume you can do it too with grub,
but I don't use grub.

Gordon
