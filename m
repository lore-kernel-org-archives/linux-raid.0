From: "Henrik Lewander" <henrik@lewander.com>
Subject: Re: messed up raid5 array
Date: Fri, 11 Jun 2004 10:47:39 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <011d01c44f90$c11f85d0$0580a8c0@europe.ad.flextronics.com>
References: <004001c44252$1845de00$7200a8c0@europe.ad.flextronics.com> <00de01c44311$6aa94640$0580a8c0@europe.ad.flextronics.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > One disk failed in my four disk raid5 array this morning. I think I
messed
> > up a bit, anyway it ended with that I removed all disks from the raid
> array.
> > Now when I add them again they show up as spares and I have no main
disks
> at
> > all. Is there a way to force the three remaining disks (excluding the
> faulty
> > one) to be an array again and not lose the current data? If I
do --create,
> > mdadm warns me that they are already a part of md1, yes but just as
> spares!
> > If I let mdadm do --create, I suppose I lose all the data? What can I
do?
>
> Replying to myself here... Can I do something like "mkraid --force" with
> mdadm? I don't have any raidtab and would prefer not to make one. I know
> about the -f flag but what I want to do is to not add the disks as spares,
I
> want them back as the normal maindisks. The data on them should be OK, but
I
> suppose some raid meta data is wrong?

Hello Henrik, this is yourself again.
Just wanted to say that if anybody gets similar problems just do another
mdadm --create with the partitions *in the same order*. Then the old
filesystem will still be present (I happened to switch the partition order
the first time I tried). Just answer yes when mdadm complains that the
partitions seem to belong to a raid array.

//Henrik

