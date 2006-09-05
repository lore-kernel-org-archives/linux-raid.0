From: Paul Waldo <pwaldo@waldoware.com>
Subject: Re: Care and feeding of RAID?
Date: Tue, 05 Sep 2006 13:39:57 -0400
Message-ID: <44FDB66D.8060202@waldoware.com>
References: <44FD722C.7050608@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FD722C.7050608@waldoware.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Waldo wrote:
> Hi all,
> 
> I have a RAID6 array and I wondering about care and feeding instructions 
> :-)
> 
> Here is what I currently do:
>    - daily incremental and weekly full backups to a separate machine
>    - run smartd tests (short once a day, long once a week)
>    - check the raid for bad blocks every week
> 
> What else can I do make sure the array keeps humming?  Thanks in advance!
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

What about bitmaps?  Nobody has mentioned them.  It is my understanding that 
you just turn them on with "mdadm /dev/mdX -b internal".  Any caveats for this?

Paul
