From: Farkas Levente <lfarkas@bnap.hu>
Subject: chunk-size
Date: Wed, 26 Mar 2003 14:02:51 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E81A4FB.6030103@bnap.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,
what is the unit of chunk-size? in the man and all exmaple I see eg:
------------------------------------
chunk-size              8
------------------------------------
but the man sed:
------------------------------------
chunk-size size
   Sets  the  stripe size to size bytes. Has to be a power of 2 and
   has a compilation-time maximum of  4M.  (MAX_CHUNK_SIZE  in  the
   kernel  driver) typical values are anything from 4k to 128k, the
   best value should be determined  by  experimenting  on  a  given
   array, alot depends on the SCSI and disk configuration.
------------------------------------
so should I wrote to 8 or 8k or 8192 ?
thanks in advance.

-- 
   Levente                               "Si vis pacem para bellum!"


