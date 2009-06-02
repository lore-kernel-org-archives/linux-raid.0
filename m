From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: RAID 5 re-add of removed drive? (failed drive replacement)
Date: Tue, 2 Jun 2009 07:20:22 -0700 (PDT)
Message-ID: <876585.41936.qm@web51304.mail.re2.yahoo.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Alex R <Alexander.Rietsch@hispeed.ch>
List-Id: linux-raid.ids





--- On Tue, 2/6/09, Alex R <Alexander.Rietsch@hispeed.ch> wrote:

> From: Alex R <Alexander.Rietsch@hispeed.ch>
> Subject: RAID 5 re-add of removed drive? (failed drive replacement)
> To: linux-raid@vger.kernel.org
> Date: Tuesday, 2 June, 2009, 11:09 AM
> 
> I have a serious RAID problem here. Please have a look at
> this. Any help
> would be greatly appreciated!
> 
> As always, most problems occur only during critical tasks
> like
> enlarging/restoring. 

....

> http://vger.kernel.org/majordomo-info.html
> 

Is this a compelling case for regular

echo check >> /sys/block/mdX/md/sync_action

and/or

echo repair >> /sys/block/mdX/md/sync_action

??

I have cron job that does this weekly.

(meant more for people that find this thread in 300yrs time)

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its own.'

Please sponsor me for the London to Brighton 2009.
Just Giving: http://www.justgiving.com/jonathanhardcastle
-----------------------


      
