From: "Eric D. Mudama" <edmudama@bounceswoosh.org>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 19:01:18 -0700
Message-ID: <20110222020118.GA30426@bounceswoosh.org>
References: <4D62CF5F.6080007@cfl.rr.com>
 <AANLkTimCU_g6hL5TX4-w6TPeFo7Wn0D+=t7iAqJ3MWcS@mail.gmail.com>
 <AANLkTincnob7V3ockg2nqO_ddeZ9UXdigoX5ZwVxocqH@mail.gmail.com>
 <AANLkTimrc0Sn8Mn9AM01rjgT1=4DsU6QLQoS3FA7Kn=8@mail.gmail.com>
 <AANLkTim8fxO3M+jEqgBHvQaxgm+MyaVz670au2wG4MkO@mail.gmail.com>
 <AANLkTim-t+69fcnan8HMsSuq+BCvVn2bfK4CRigO_iHn@mail.gmail.com>
 <20110222003610.GB29101@bounceswoosh.org>
 <AANLkTinH+2fbEHmO2CNrBtg2MEPCMG3Q-qcsMW5Ccce9@mail.gmail.com>
 <AANLkTi=-hJ5SeTsUNT=in0GBNUQB=4uvdumrvuakZXgq@mail.gmail.com>
 <AANLkTim_F1wqvLprPvytVAMLnbDcr71ys-38WcsFpFkB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTim_F1wqvLprPvytVAMLnbDcr71ys-38WcsFpFkB@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Mathias =?iso-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, "Eric D. Mudama" <edmudama@bounceswoosh.org>, Phillip Susi <psusi@cfl.rr.com>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 21 at 22:55, Roberto Spadim wrote:
>it can be used for badblock reallocation if harddisk have it
>a harddisk is near to NOR ssd with variable accesstime, if head is
>near sector to be read/write accesstime is small, if sector is far
>from head, access time increase (normaly <=1 disk revolution if head
>control system is good, for 7200rpm 1revolution is near to 8.33ms)

Hard disks do not expose their defect information/remappings.  They
present a defect-free logical region to the host.

Optimizing for a few hundred thousand remapped sectors across the LBA
range of ~6 billion LBAs on a 3TB drive isn't worth the effort or code
complexity in most cases.

I still don't see how TRIM helps a rotating drive.

-- 
Eric D. Mudama
edmudama@bounceswoosh.org

