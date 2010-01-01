From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: Size limitation?
Date: Fri, 01 Jan 2010 16:32:43 -0500
Message-ID: <4B3E69FB.9020604@scalableinformatics.com>
References: <201001011457.24334.mmclagan@invlogic.com>
Reply-To: landman@scalableinformatics.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201001011457.24334.mmclagan@invlogic.com>
Sender: linux-raid-owner@vger.kernel.org
To: mmclagan+reply@invlogic.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael McLagan wrote:
> Hello,
> 
>    I'm trying to set up a large array but isn't working.  I tried 
> Googling size limits, etc and came up empty.
> 
> The problem is that with 10 drives (300GB SCSI), the array is coming up 
> with 500GB of space?!?  I did an experiment and when the array size 
> exceeds 2TB, it fails/wraps?

Is this a 32 bit machine?

	uname -a

might help.



-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/jackrabbit
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
