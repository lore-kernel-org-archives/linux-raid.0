From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ANNOUNCE: mdadm 1.7.0 - A tool for managing Soft RAID under
 Linux
Date: Thu, 12 Aug 2004 09:04:21 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16666.42485.178856.530123@cse.unsw.edu.au>
References: <16665.33913.505058.370245@cse.unsw.edu.au>
	<20040811155507.307d91d0.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jure  =?ISO-8859-1?Q?=20Pe=E8ar?= on Wednesday August 11
To: Jure =?UTF-8?Q?Pe=C3=A8ar?= <pegasus@nerv.eu.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 11, pegasus@nerv.eu.org wrote:
> On Wed, 11 Aug 2004 12:29:13 +1000
> Neil Brown <neilb@cse.unsw.edu.au> wrote:
> 	 
> >     -   Add support for "raid10", which is under development in 2.6.
> > 	Not documented yet.
> 
> Where can one read more about this? I assume it's going to be a sepparate
> raid personality, not just raid0 over raid1? Or is it going to be a dm
> mapping scheme?
> 

It is a separate personality that has combined raid1 and raid0
features.
Data is laid out in a raid0 style, but multiple copies of each chunk
are possible.  There can be "near" copies, where copies of the one
block are at the same or similar offsets in different drives, and
"far" copies, where copies of the one block are at a substantial
offset from one drive to the next.
e.g. 2 near copies on a 3 drive array would look like?
  drive1  drive2  drive2
    A       A       B
    B       C       C
    D       D       E
    E       F       F
    :       :       :

2 far copies on a 3 drive array would look like

    A       B       C
    D       E       F
    G       H       I
    :       :       :
    C       A       B
    F       D       E
    I       G       H
    :       :       :

My current code substantially works, but there are a few bugs left in
it.  You can find it by hunting around in:

http://neilb.web. cse.unsw.edu.au/patches/linux-devel/2.6/2004-08-11-22/


I included raid10 support in mdadm 1.7.0 so that as soon as the kernel
patch was ready, people would be able to try it out.

NeilBrown
