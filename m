From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: BUG:write data to degrade raid5
Date: Sun, 21 Mar 2010 10:04:26 -0300
Message-ID: <20100321130426.GB15746@khazad-dum.debian.net>
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
 <4BA3C07A.8030204@gmx.net>
 <73e903671003191123h1b7e1196v336265842f1b29e5@mail.gmail.com>
 <4BA3C461.5060209@gmx.net>
 <de04351e1003210329w21f4731as3597245562a390d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <de04351e1003210329w21f4731as3597245562a390d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jin zhencheng <zhenchengjin@gmail.com>
Cc: Joachim Otahal <Jou@gmx.net>, Kristleifur =?iso-8859-1?Q?Da=F0ason?= <kristleifur@gmail.com>, neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 21 Mar 2010, jin zhencheng wrote:
> ths for your test on "Debian 2.6.26-21lenny4".
> if you want to see the oop ,you should always write to the raid5 ,and
> pull 2 disks out.maybe you can see the error
> 
> i think no matter what i do ,even if i pull out all the disk , kernel
> should not oop.

You don't have swap (file or partition, doesn't matter) on that RAID, do
you?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
