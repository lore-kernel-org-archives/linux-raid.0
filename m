From: rob <rob@fantinibakery.com>
Subject: Re: raid0 and iscsi
Date: Mon, 13 Oct 2003 20:45:38 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F8B4732.20609@fantinibakery.com>
References: <200310130434.h9D4YU0n020486@bach.cs.colostate.edu> <3F8A9736.1020706@fantinibakery.com> <3F8B365F.9060509@fantinibakery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F8B365F.9060509@fantinibakery.com>
To: rob <rob@fantinibakery.com>
Cc: Jayshankar Nair <jshankar@CS.ColoState.EDU>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

here is result of writting 3-gb over lan :

1- to h/w raid system:  8,384,582.41 bytes/sec

2- to ide disk: 5,046,348.67 bytes/sec

3- to software raid system: 6,678,231.03 bytes/sec

 the h/w system has fasrer disks than the s/w raid. 


>
> the test I did faulty.  I mistakenly sent data to a non-raid disk on 
> the software raid computer.
> for kicks I'll retest and post the results sometime soon.
>
>>
>> the command used: rsync -e ssh -a --stats  /bkup3/  fbc5:/bkup3/
>>
>> here is the result of sending approx 3-gb of data to each:
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


