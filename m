From: Wolfgang Denk <wd@denx.de>
Subject: Re: Software raid - controller options
Date: Tue, 06 Nov 2007 09:16:14 +0100
Message-ID: <20071106081614.B5294249E7@gemini.denx.de>
References: <1194319214.17361.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Tue, 06 Nov 2007 06:20:14 +0300."
             <1194319214.17361.36.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Lyle Schlueter <lyle@xkubed.com>
Cc: Richard Scobie <richard@sauce.co.nz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In message <1194319214.17361.36.camel@localhost.localdomain> you wrote:
> 
> I had been looking at the Adaptec 2240900-R PCI Express and HighPoint
> RocketRAID 2300 PCI Express. These are both *raid* cards. But if they
> can be used as a regular controller card, they both provide 4 SATA ports
> and are PCI-e. But sounds like the RocketRAID doesn't work with the
> 2.6.22+ kernel (according to newegg reviewers). It sounds like the
> Adaptec works quite nicely though. 

Be careful. Ideally, the controller should be  supported  by  drivers
that  are included withthe standard kernel.org Linux tree. If this is
not the case,  try  to  find  out  if  you  get  Linux  drivers  with
*complete*  source  code. Both Highpoint (RocketRAID) and Adaptec are
known to include binary-only modules in their drivers, even  if  they
seem  to provide source code. This is always a PITA and may seriously
mimit your on specific *usually very old) kernel versions.

> Sounds pretty iffy there. That Adaptec card I mentioned is going for
> about 100 USD. Seems like a lot for 4 ports. But sounds like it works

I returned such a card because I could not get it working with the
kernel versions I wanted to run.

On the other hand, the Supermicro card worked fine for me out of the
box.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
When a woman marries again it is because she detested her first  hus-
band.  When  a  man  marries again, it is because he adored his first
wife.                                                  -- Oscar Wilde
