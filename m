From: Neil Brown <neilb@suse.de>
Subject: RE:   RAID 6 grow problem
Date: Thu, 7 Jun 2007 14:44:04 +1000
Message-ID: <18023.36116.726823.425259@notabene.brown>
References: <1501701006.1181142416422.JavaMail.root@gateway.korstad.net>
	<Pine.LNX.4.64.0706061021530.5806@gheavc.wnzcbav.cig>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Wednesday June 6
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Daniel Korstad <dan@korstad.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 6, jnelson-linux-raid@jamponi.net wrote:
> 
> A question posed by a friend is this: assuming 64K blocks, if I read a 
> single stripe from a raid (128K, right?) then two drives will be used 
> (say, drive A and drive B). If I want the "next" 128K then which drives 
> are most likely to be used? Drive A will now have the parity block in 
> it's "next" block for head position, but drive B has the next data 
> block. Nobody knows where drive C is. Does raid5 use an algorithm 
> similar to raid1 in that it chooses the 2 drives whose heads are closest 
> or does it utilize some other algorithm? 

No.  When it wants data, it just reads the data.  It doesn't try to be
clever an read the parity block and calculate the data (unless the
data block doesn't exist of course).

NeilBrown
