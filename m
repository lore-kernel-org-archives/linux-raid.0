From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid 5 on linux --againnnn (sorryy it's big)
Date: Fri, 25 Jul 2003 16:59:10 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16160.54590.801766.639186@gargle.gargle.HOWL>
References: <16160.54202.936629.967811@gargle.gargle.HOWL>
	<36863.202.158.96.2.1059115951.power.web.id@mail2.oke.net.id>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from c4c3m@oke.net.id on Friday July 25
To: c4c3m@oke.net.id
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 25, c4c3m@oke.net.id wrote:
> so what should i do to make my data is not lost ??
> is there any suggestion??
> 

Which md device has /var ???
Did you run exactly the command that I said to run to assemble it?

What does 
   mdadm -D /dev/mdX
say, where /dev/mdX is the md device with /var on it?

NeilBrown
