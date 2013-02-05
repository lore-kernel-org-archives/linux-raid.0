From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: 3TB drives failure rate (summary)
Date: Wed, 06 Feb 2013 04:43:03 +1100
Message-ID: <511144A7.4050208@websitemanagers.com.au>
References: <11510711257.20121028131527@oudeis.org> <508D61A1.7020106@wildgooses.com> <508D65CF.1080904@gmail.com> <508DADC3.4080104@shiftmail.org> <508DB08D.20002@meetinghouse.net> <508DC6E9.8070001@shiftmail.org> <508DC922.7040400@meetinghouse.net> <20121029102919.1134a797@natsu> <508E3626.8080404@hesbynett.no> <508E7E68.1030202@turmel.org> <1494377384.20121031005457@oudeis.org> <50911AFF.9020707@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50911AFF.9020707@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: =?UTF-8?B?UmFpbmVyIEbDvGdlbnN0ZWlu?= <rfu@oudeis.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31/10/12 23:35, Phil Turmel wrote:
> I strongly encourage you to run "smartctl -l scterc /dev/sdX" for each
> of your drives.  For any drive that warns that it doesn't support SCT
> ERC, set the controller device timeout to 180 like so:
>
> echo 180 >/sys/block/sdX/device/timeout
>
> If the report says read or write ERC is disabled, run "smartctl -l
> scterc,70,70 /dev/sdX" to set it to 7.0 seconds.
>
> You then set up a boot-time script to do these adjustments at every restart.

I'm using some SSD's in a RAID, but smartctl -l scterc /dev/sdX says it
doesn't support it.

Do SSD's not support it because it is not relevant (ie, either the data
is there or not, we always know immediately, never any "retry" or whatever?)

Or, should I be concerned about this?

Thanks,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

