From: "Andrew Skolarz" <pletopia@gmail.com>
Subject: Re: PLEASE HELP ... raid5 array degraded - how fix it?
Date: Sat, 15 Jul 2006 12:29:56 -0500
Message-ID: <51adc5d50607151029t3b074a42v4ba88b2f1156c6b0@mail.gmail.com>
References: <51adc5d50607112009v476d680fqe9918d607b90def4@mail.gmail.com>
	 <51adc5d50607112016u428b48efx335dc704bb91dfb7@mail.gmail.com>
	 <51adc5d50607112110s37a1ed83v65fd0b17f1d20dda@mail.gmail.com>
	 <200607151603.24228.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200607151603.24228.Dexter.Filmore@gmx.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i just forced a re-assemble ... and then it fixed it self

mdm -A --force /dev/md0 /dev/hd[ijk]1  (forced re-assemble on the 3 good drives)
mdm -a /dev/md0 /dev/hdl1 (re-added the bad drive and it fixed itself)
