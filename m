From: "Eric D. Mudama" <edmudama@bounceswoosh.org>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 17:36:10 -0700
Message-ID: <20110222003610.GB29101@bounceswoosh.org>
References: <AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>
 <AANLkTimxTBTGupRk_1nSajjoWBstHdzVVpF4kEN3Y6XU@mail.gmail.com>
 <AANLkTikR+bKrGUCxnsnNz0vJVGOWoPiP0b618sZNBdqU@mail.gmail.com>
 <AANLkTik+xMXqA1+bM=AAhsqtCha-rDcVNr3Qkd-AmbNY@mail.gmail.com>
 <4D62CF5F.6080007@cfl.rr.com>
 <AANLkTimCU_g6hL5TX4-w6TPeFo7Wn0D+=t7iAqJ3MWcS@mail.gmail.com>
 <AANLkTincnob7V3ockg2nqO_ddeZ9UXdigoX5ZwVxocqH@mail.gmail.com>
 <AANLkTimrc0Sn8Mn9AM01rjgT1=4DsU6QLQoS3FA7Kn=8@mail.gmail.com>
 <AANLkTim8fxO3M+jEqgBHvQaxgm+MyaVz670au2wG4MkO@mail.gmail.com>
 <AANLkTim-t+69fcnan8HMsSuq+BCvVn2bfK4CRigO_iHn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTim-t+69fcnan8HMsSuq+BCvVn2bfK4CRigO_iHn@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Mathias =?iso-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Phillip Susi <psusi@cfl.rr.com>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 21 at 20:52, Roberto Spadim wrote:
>trim tell harddisk that those block are not in use

yes

>not in use block can be used by harddisk reallocation algorithm, like
>spare sectors

no, because the host may immediately write to a trim'd sector

The spares in an HDD can never be accessed outside of special tools,
they're swap-in replacements for regions of the media that have
developed defects.

>hard disks can use TRIM command to 'create' 'good' blocks like spare sectors

this doesn't make sense to me


-- 
Eric D. Mudama
edmudama@bounceswoosh.org

