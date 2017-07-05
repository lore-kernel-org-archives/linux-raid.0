From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Linear device of two arrays
Date: Wed, 5 Jul 2017 19:07:22 +0100
Message-ID: <595D2ADA.8010907@youngman.org.uk>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com>
 <20170705214250.0ea99538@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170705214250.0ea99538@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, Veljko <veljko3@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/07/17 17:42, Roman Mamedov wrote:
> On Wed, 5 Jul 2017 17:34:09 +0200
> Veljko <veljko3@gmail.com> wrote:
> 
>> Hello,
>>
>> I have a RAID10 device which I have formated using the mkfs.xfs
>> defaults (Stan helped me with this few years back). I reached 88%
>> capacity and it is time to expand it. I bought 4 more drives to create
>> another RIAD10 array. I would like to create linear device out of
>> those two and grow XFS across the 2nd device. How can this be done
>> without loosing the existing device's data? I would also like to add a
>> spare HDD. Do I have to have a separate spare HDD for each array or
>> one can be used by both of them?
> 
> Why make another RAID10? With modern versions of mdadm and kernel you should
> be able to simply reshape the current RAID10 to increase the number of
> devices used from 4 to 8.
> 
> 
I was thinking of replying, but isn't that not possible for some
versions of RAID-10?

My feeling was, if you can't just add drives to the existing raid 10,
create a new one which you can expand, migrate the fs across (btrfs
would let you do that live, I believe, so xfs probably can too), then
you can scrap the old raid-10 and add the drives into the new one.

Cheers,
Wol
