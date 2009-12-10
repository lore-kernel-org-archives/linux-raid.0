From: Asdo <asdo@shiftmail.org>
Subject: Re: Disappointing performance of copy (MD raid + XFS)
Date: Thu, 10 Dec 2009 02:16:35 +0100
Message-ID: <4B204BF3.1000600@shiftmail.org>
References: <4B204334.1000605@shiftmail.org> <4B204783.7040109@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4B204783.7040109@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Asdo wrote:
> Asdo wrote:
>> and I think I have seen around 10MB/sec when they are of 500KB (this 
>> transfer at 10MB/sec was in parallel with another faster one however). 
> Yes I definitely confirm: right now I have just 1 rsync copy running, 
> it's in a zone where files are around 500KB on average, and it's going 
> at 9 MB/sec.
> Stack traces of the writer process conform to what I have posted in my 
> previous email, even now that the writer is the only process using the 
> destination array.
Excuse me, I am going nuts...
In this case of 9MB/sec for 500KB files, stack traces on the writer are 
indeed very similar to what I have posted, but the relative frequency of 
the two type of stack traces is different:
20%: waiting on the reader (this almost never happened when using 
multiple parallel rsyncs)
50%: xlog_state_get_iclog_space+0xed/0x2d0
30%: xfs_buf_lock+0x1e/0x60


The reader is waiting either on select (on the writer I guess) or on this:
  [<ffffffff810da74d>] sync_page+0x3d/0x50
  [<ffffffff810da769>] sync_page_killable+0x9/0x40
  [<ffffffff810da682>] __lock_page_killable+0x62/0x70
  [<ffffffff810db8be>] T.768+0x1ee/0x440            
  [<ffffffff810dbbc6>] generic_file_aio_read+0xb6/0x1d0
  [<ffffffffa031cd95>] xfs_read+0x115/0x2a0 [xfs]     
  [<ffffffffa031832b>] xfs_file_aio_read+0x5b/0x70 [xfs]
  [<ffffffff8111ec32>] do_sync_read+0xf2/0x130         
  [<ffffffff8111f215>] vfs_read+0xb5/0x1a0             
  [<ffffffff8111f81c>] sys_read+0x4c/0x80              
  [<ffffffff81012002>] system_call_fastpath+0x16/0x1b  
  [<ffffffffffffffff>] 0xffffffffffffffff              


