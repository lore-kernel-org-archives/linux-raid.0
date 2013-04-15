From: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Subject: Re: Odd --examine output
Date: Mon, 15 Apr 2013 13:46:43 +0000
Message-ID: <CD917B51.41713%michael.vanhorn@wright.edu>
References: <51681FB2.8060803@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51681FB2.8060803@turmel.org>
Content-Language: en-US
Content-ID: <82136C1225848F4A895778414F290C3F@prod.exchangelabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/12/13 10:52 AM, "Phil Turmel" <philip@turmel.org> wrote:

>NOT a guess.  Back up what you can, while you can, and start over.  Use
>"fdisk -u" so you can ensure partitions start on multiples of eight (8)
>sectors.  (Modern fdisk uses 1MB alignment by default.  Highly
>recommended.)
>
>

So, if I start the partition at sector 64 (rather than 63), that's better,
right (since 64 is a multiple of 8)? Or is there more math to do and I'm
still not getting it?

---
Mike VanHorn
Senior Computer Systems Administrator
College of Engineering and Computer Science
Wright State University
265 Russ Engineering Center
937-775-5157
michael.vanhorn@wright.edu
http://www.cecs.wright.edu/~mvanhorn/




