From: Tejun Heo <tj@kernel.org>
Subject: Re: hdaprm -Y /dev/sda /dev/sdb -> I/O error -> disk kicked out of
 RAID - is it normal?
Date: Fri, 17 Jul 2009 13:12:54 +0900
Message-ID: <4A5FFA46.1070203@kernel.org>
References: <4A5FB1DD.3000904@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A5FB1DD.3000904@wpkg.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Chmielewski wrote:
> And one of the disks is kicked out of RAID.
> 
> Is it expected behaviour (although probably the error happens somewhere
> in the ata layer)?

Yes, it's expected.  Wakeup requires reset via EH and md requests have
FAILFAST flag set, so they never get retried.  The behavior can be
changed tho.  Hmmm... not entirely sure what to do at this point.

Thanks.

-- 
tejun
