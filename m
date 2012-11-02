From: Sebastian Hegler <sebastian.hegler@tu-dresden.de>
Subject: Re: mdadm recovery after HW failure: missing blocks at the end
Date: Fri, 2 Nov 2012 16:49:15 +0100
Message-ID: <478FF889-D015-4863-835B-BC9A167E57FC@tu-dresden.de>
References: <976F9B53-9E94-4684-B714-6F1FFD4FBFEF@tu-dresden.de>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <976F9B53-9E94-4684-B714-6F1FFD4FBFEF@tu-dresden.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi all!

For the record:

Am 01.11.2012 um 22:03 schrieb Sebastian Hegler:
> * Did mdadm (or the kernel md driver) write to the end area of the disk?
Apparently no.

> * Is it possible to make mdadm give me back the 128kiB at the end of each device?
Yes:
diff --git a/super1.c b/super1.c
index 5bb1f01..4824aa3 100644
--- a/super1.c
+++ b/super1.c
@@ -1723,8 +1723,8 @@ static __u64 _avail_size1(struct supertype *st, __u64 devs
        /* Allow space for bad block log */
        if (super && super->bblog_size)
                devsize -= __le16_to_cpu(super->bblog_size);
-       else
-               devsize -= 8;
 
 
        if (st->minor_version < 0)



Yours,
Sebastian

