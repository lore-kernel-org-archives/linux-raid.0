From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: SOLVED: forcing boot ordering of multilevel RAID arrays
Date: Sun, 7 Aug 2005 20:45:40 -0700 (PDT)
Message-ID: <Pine.LNX.4.63.0508072038370.1390@twinlark.arctic.org>
References: <200508072108.j77L8ZPt019570@pog.tecnopolis.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200508072108.j77L8ZPt019570@pog.tecnopolis.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Trevor Cordes <trevor@tecnopolis.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 7 Aug 2005, Trevor Cordes wrote:

> Any array that is a superset of other arrays (a multilevel array) must
> set to non-autodetect.  Use fdisk to change the parition type to 83
> (standard linux), NOT "fd" (linux raid autodetect).

you know i'd be worried setting it to 0x83 will cause troubles now and 
then with tools assuming it's really a filesystem... personally i've used 
0xDA "Non-FS data" for such things in the past.  i didn't really see any 
type more appropriate... i'm hoping no tool assumes anything about 0xDA.

-dean
