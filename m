From: Wolfgang Denk <wd@denx.de>
Subject: Re: 3TB drives failure rate (summary)
Date: Tue, 05 Feb 2013 21:34:30 +0100
Message-ID: <20130205203430.D53EA20055D@gemini.denx.de>
References: <11510711257.20121028131527@oudeis.org> <508D61A1.7020106@wildgooses.com> <508D65CF.1080904@gmail.com> <508DADC3.4080104@shiftmail.org> <508DB08D.20002@meetinghouse.net> <508DC6E9.8070001@shiftmail.org> <508DC922.7040400@meetinghouse.net> <20121029102919.1134a797@natsu> <508E3626.8080404@hesbynett.no> <508E7E68.1030202@turmel.org> <1494377384.20121031005457@oudeis.org> <50911AFF.9020707@turmel.org> <511144A7.4050208@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <511144A7.4050208@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Phil Turmel <philip@turmel.org>, =?UTF-8?B?UmFpbmVyIEbDvGdlbnN0ZWlu?= <rfu@oudeis.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Adam Goryachev,

In message <511144A7.4050208@websitemanagers.com.au> you wrote:
>
> I'm using some SSD's in a RAID, but smartctl -l scterc /dev/sdX says it
> doesn't support it.
> 
> Do SSD's not support it because it is not relevant (ie, either the data
> is there or not, we always know immediately, never any "retry" or whatever?)

It depends on the type of SSD, I think.

On an Intel 320 Series SSD (SSDSA2CW120G3) I see this:

# smartctl -l scterc /dev/sdg
smartctl 6.0 2012-10-10 r3643 [x86_64-linux-3.6.10-2.fc17.x86_64] (local build)
Copyright (C) 2002-12, Bruce Allen, Christian Franke, www.smartmontools.org

SCT Error Recovery Control:
           Read:    100 (10.0 seconds)
          Write:    100 (10.0 seconds)


Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
 The software required `Windows 95 or better', so I installed Linux.
