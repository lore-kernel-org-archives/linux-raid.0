From: Sandro Dentella <sandro@e-den.it>
Subject: device that *thinks* to be a spare...
Date: Thu, 9 Mar 2006 00:02:01 +0100
Message-ID: <20060308230200.GA10856@casa.e-den.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yersterday i toubled with system crash due to an md device that stopped due
to an error on a single block (sata controller).

Starting from a live rescue cd to analize the situation I found that the
array thought the good disk was the one had the block failure, so
that reconstruction arrived at 75% and then restarted (I saw that
happending).

I eliminated the bad disk and the other couldn't start complaining it was a
spare one (but no one was configured as spare...) so that there where no
good disk. I had to turn it into a normal /dev/sda disk to be able to start
the system. 

My question is if there is a way to convince a device that it is the good
device w/o destroying the array and how it can happen that an array
component turns into a spare one.

What should I have one?

TIA
sandro
*:-)
