From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Growing RAID10 with active XFS filesystem
Date: Mon, 8 Jan 2018 16:34:08 +0100
Message-ID: <1d05f29a-0b33-d816-3512-035e07c85c92@thelounge.net>
References: <4892a03d-018c-8281-13d3-4fcc7acd2bb8@gmail.com>
 <232deaaa-7306-a01b-567f-ca5c74dc6077@suse.com>
 <5A538B30.4080601@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A538B30.4080601@youngman.org.uk>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Guoqing Jiang <gqjiang@suse.com>, mdraid.pkoch@dfgh.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 08.01.2018 um 16:16 schrieb Wols Lists:
> On 08/01/18 07:31, Guoqing Jiang wrote:
>> https://raid.wiki.kernel.org/index.php/Growing#Extending_the_filesystem
>>
>> And you can use xfs_growfs for your purpose.
> 
> You extend the filesystem *after* you've grown the array. The act of
> growing the array has caused the filesystem to crash. That should NOT
> happen - the act of growing the array should be *invisible* to the
> filesystem.
> 
> In other words, one or more of the following three are true :-
> 1) The OP has been caught by some random act of God
> 2) There's a serious flaw in "mdadm --grow"
> 3) There's a serious flaw in xfs
3) should not be possible because as long 2) is running the filesystem 
should not know that anything is changing at all - even "should" is the 
wrong word: MUST NOT
