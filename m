From: Chris Allen <chris@cjx.com>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Fri, 23 Jun 2006 13:50:09 +0100
Message-ID: <449BE381.6070000@cjx.com>
References: <449AEB7C.6040108@cjx.com> <op.tblclqd3cigqcu@apollo13> <fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Francois Barre wrote:
> 2006/6/23, PFC <lists@peufeu.com>:
>>
>>         - XFS is faster and fragments less, but make sure you have a 
>> good UPS
> Why a good UPS ? XFS has a good strong journal, I never had an issue
> with it yet... And believe me, I did have some dirty things happening
> here...
>
>>         - ReiserFS 3.6 is mature and fast, too, you might consider it
>>         - ext3 is slow if you have many files in one directory, but 
>> has more
>> mature tools (resize, recovery etc)
> XFS tools are kind of mature also. Online grow, dump, ...
>
>>
>>         I'd go with XFS or Reiser.
> I'd go with XFS. But I may be kind of fanatic...

Strange that whatever the filesystem you get equal numbers of people 
saying that
they have never lost a single byte to those who have had horrible 
corruption and
would never touch it again. We stopped using XFS about a year ago because we
were getting kernel stack space panics under heavy load over NFS. It 
looks like
the time has come to give it another try.

