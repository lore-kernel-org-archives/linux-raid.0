From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Fri, 11 Jun 2010 00:42:24 -0400
Message-ID: <4C11BEB0.6010108@meetinghouse.net>
References: <4C1128C2.4020105@meetinghouse.net>	<20100611005743.43664e5b@natsu>	<4C11578B.8010202@meetinghouse.net>	<20100611034108.6a2cdbc4@natsu>	<4C1169CB.1030903@meetinghouse.net> <20100611085112.5f33b06f@natsu> <001501cb091f$07ac4e40$1704eac0$@woodlea.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001501cb091f$07ac4e40$1704eac0$@woodlea.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Graham Mitchell wrote:
> Can you do this on a live array, or can it only be done (as the docs seem to
> suggest), with the create, build and grow options?
>
>
>    
I just did it on a live array.  Some --grow options, including --bitmap, 
seem to work on live arrays.

Miles

-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


