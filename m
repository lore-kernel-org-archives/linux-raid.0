From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm --assemble --scan hassles....
Date: Wed, 29 Oct 2003 11:04:13 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16287.1021.187640.232407@notabene.cse.unsw.edu.au>
References: <20031008111709.GV1277@hvs.envisage.co.za>
	<16270.5184.302596.951547@notabene.cse.unsw.edu.au>
	<20031025212433.GE23767@hvs.envisage.co.za>
	<16285.38655.754527.236684@notabene.cse.unsw.edu.au>
	<20031028062445.GD3236@hvs.envisage.co.za>
	<3F9E5369.6050203@fantinibakery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from rob on Tuesday October 28
To: rob <rob@fantinibakery.com>
Cc: Hendrik Visage <hvisage@envisage.co.za>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 28, rob@fantinibakery.com wrote:
> AFAIK you don't need DEVICE and ARRAY entries in mdadm.conf
> 
> I only use MAILADDR    PROGRAM    entries to monitor the array.
> 

It depends on what you want mdadm to do for you.

If you want it to assemble your arrays, then DEVICE and ARRAY help
alot.
If you only want it to monitor your arrays, then MAILADDR and PROGRAM
are all you need.

NeilBrown
