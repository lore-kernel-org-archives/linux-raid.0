From: Hendrik Visage <hvisage@envisage.co.za>
Subject: Re: mdadm --assemble --scan hassles....
Date: Wed, 29 Oct 2003 07:47:18 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031029054718.GB3236@hvs.envisage.co.za>
References: <20031008111709.GV1277@hvs.envisage.co.za> <16270.5184.302596.951547@notabene.cse.unsw.edu.au> <20031025212433.GE23767@hvs.envisage.co.za> <16285.38655.754527.236684@notabene.cse.unsw.edu.au> <20031028062445.GD3236@hvs.envisage.co.za> <3F9E5369.6050203@fantinibakery.com> <16287.1021.187640.232407@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16287.1021.187640.232407@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: rob <rob@fantinibakery.com>, Hendrik Visage <hvisage@envisage.co.za>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 29, 2003 at 11:04:13AM +1100, Neil Brown wrote:
> It depends on what you want mdadm to do for you.
> 
> If you want it to assemble your arrays, then DEVICE and ARRAY help
> alot.
> If you only want it to monitor your arrays, then MAILADDR and PROGRAM
> are all you need.

True,

 But it still doesn't solve my original problem, being that mdadm
didn't picked up the md that should go into the next md :(

HEndrik
