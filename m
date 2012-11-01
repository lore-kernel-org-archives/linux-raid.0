From: Wolfgang Denk <wd@denx.de>
Subject: Re: Best way (only?) to setup SSD's for using TRIM
Date: Thu, 01 Nov 2012 16:01:44 +0100
Message-ID: <20121101150144.6BA1D2005D0@gemini.denx.de>
References: <508D808A.7040100@curtronics.com> <508FA2C6.2050800@hesbynett.no> <508FE44A.3040507@curtronics.com> <508FF85F.1030308@hesbynett.no> <Pine.LNX.4.64.1210301306470.20143@router.curtronics.com> <B371ADF3-F328-4E1B-A6D2-87DE1974D8FF@colorremedies.com> <5090E239.9040302@hesbynett.no> <50916132.3010405@curtronics.com> <50918432.906@hesbynett.no> <5091D63E.1080007@curtronics.com> <50922FA4.7070702@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <50922FA4.7070702@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Curtis J Blank <curt@curtronics.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear David,

In message <50922FA4.7070702@hesbynett.no> you wrote:
>
> If you make your big raid1 pair an LVM physical volume, you can split it 
> into logical volumes as and when you want, and re-size them whenever 
> necessary.  Note, however, that the unpartitioned space within the LVM 
> physical volume is still "used" as far as the SSD is concerned, since 
> the initial raid1 synchronisation has written to it.  So only space 

What if the creation of the array was done with "--assume-clean" ?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Common sense and a sense of humor  are  the  same  thing,  moving  at
different speeds.  A sense of humor is just common sense, dancing.
                                                        - Clive James
