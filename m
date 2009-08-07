From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Draft Mirrored Linux Mini How-to
Date: Fri, 07 Aug 2009 04:09:13 +0200
Message-ID: <87ocqse5o6.fsf@frosties.localdomain>
References: <4A78292A.5000607@in.ibm.com> <1249421223.18245.36.camel@pasglop>
	<4A794E26.8080207@in.ibm.com> <1249465934.18245.54.camel@pasglop>
	<4A7ADBB1.3050906@in.ibm.com> <1249595469.24311.5.camel@pasglop>
	<4A7B708F.4050406@uga.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A7B708F.4050406@uga.edu> (Harold Pritchett's message of "Thu,
	06 Aug 2009 20:08:47 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: harold@uga.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Harold Pritchett <harold@uga.edu> writes:

> Following this note is a draft of a "Mirrored Linux Mini How-to" document.
> It's primarily for my own use, but I will make it available to anyone who
> would like a copy.
>
> Before I do this, I would like input from this group as to whether it:
> 1. is a good idea?
> 2. has no obvious errors or problems?
> 3. will reliably work?
> 4. Should I provide more details?  Or at least pointers to using fdisk, etc.
>
> Thanks for the assistance
>
> Harold
>
> ==============================================================================
>
> Mirrored Linux Mini How-to
>
> Install linux on two identical disk drives in such a way that the failure
> of either of the drives will allow the system to be recovered without any
> loss of data
>
> Both of the drives are partitioned exactly the same:
>      1.  3 primary partitions
>      2.  Partition 1 - size - 1GB format as Linux Raid (fd)
>      3.  Partition 2 - size = real memory size, format as linux swap (82)
>      4.  Partition 3 = size = remainder of disk, format as linux raid (fd)

Grub2 can boot from lvm on raid and swap can be on lvm too. So all you
really need is one partition.

Also the size of swap depends on the amount of ram. The more ram you
have the less swap you need. Unless you want to do suspend to swap
picking the size of swap by the ram size is pointless.

> To ensure that the partitions are correct, and in the correct order, boot from
> the install CD/DVD and run the rescue system.  Use fdisk from this system
> to partition the two drives.  (The GUI disk partitioner which runs in the
> anaconda installer has a tendency to move partitions around without asking.
> We don't want this to happen!)  After saving the partition information on
> both drives, you can Run the Linux installer.  Select "custom" installation.

Insert Debian CD/DVD. Boot installer and configure raid1 when you get
to the point about partitioning.

Do you really need a HowTo for that?

MfG
        Goswin
