From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Sun, 2 Mar 2008 14:33:32 +0100
Message-ID: <bb145bd20803020533v7310c2dn51c914eae5cb6cdb@mail.gmail.com>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
	 <alpine.DEB.1.00.0803020741150.13994@p34.internal.lan>
	 <bb145bd20803020456g54be4bcbg1cf7aed132ac7944@mail.gmail.com>
	 <alpine.DEB.1.00.0803020802370.18550@p34.internal.lan>
	 <20080302142331.22d399e7@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080302142331.22d399e7@absurd>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >  Disable NCQ and your problem will go away.
>
>  maybe there is a jumper on HDD to disable it?

No jumper, but it looks pretty disabled to me anyway.
The drives do have a jumper that halves the bus speed to 150MB/s but
AFAICS that leaves the other SATA II features untouched.

C.
