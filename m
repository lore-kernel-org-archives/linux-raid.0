From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Bad block on IDE drive causes it to be kicked out of the array
Date: Mon, 8 Jul 2002 18:16:38 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15657.19046.986108.967800@notabene.cse.unsw.edu.au>
References: <001f01c22632$ad349580$0200a8c0@gandalf>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Chabot on Monday July 8
To: Chris Chabot <chabotc@xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday July 8, chabotc@xs4all.nl wrote:
> 
> is there any way to create the array, and just mark these blocks bad in the
> file system, as you would with a 'normal' drive?
> 
No.

(if you use raid5, you care about your data, and if you care about
your data, you don't use a drive with bad blocks.  Atleast, that is my
logic.)

NeilBrown
