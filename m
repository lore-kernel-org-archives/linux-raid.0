From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: md manpage of mdadm 2.5.6
Date: Sun, 19 Nov 2006 08:35:46 -0500
Message-ID: <45605DB2.50000@tmr.com>
References: <200611091504.19745.jwagner@computing.dcu.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200611091504.19745.jwagner@computing.dcu.ie>
Sender: linux-raid-owner@vger.kernel.org
To: Joachim Wagner <jwagner@computing.dcu.ie>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Joachim Wagner wrote:
> Hi Neil,
>
> In man -l mdadm-2.5.6/md.4 I read
>
> "Firstly, after an unclear shutdown, the resync process will consult the 
> bitmap and only resync those blocks that correspond to bits in the bitmap 
> that are set. This can dramatically increase resync time."
>
> IMHO, "increase" should be changed to "decrease" or "time" to "speed". 
>   

Probably better to say "unclean" than "unclear" shutdown as well.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

