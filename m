From: Benjamin ESTRABAUD <ben.estrabaud@mpstor.com>
Subject: Re: Failure propagation of concatenated raids ?
Date: Wed, 15 Jun 2016 10:29:54 +0100
Message-ID: <57612012.9080902@mpstor.com>
References: <CAAkR8+s1=P5+4w0JBLs71DFtqQiD+x4mssjvL4utmb0HGOfLEg@mail.gmail.com> <22368.45414.256389.605050@quad.stoffel.home> <CAAkR8+vfXJOtYUBvkZXxQhXwh-e2t6yGuarLW4MGS8B+YKtUZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAkR8+vfXJOtYUBvkZXxQhXwh-e2t6yGuarLW4MGS8B+YKtUZg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Noble <nicolas@nobis-crew.org>, John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/06/16 10:18, Nicolas Noble wrote:
>> it
>> *might* make sense to look at ceph or some other distributed
>> filesystem.
>
> I was trying to avoid that, mainly because that doesn't seem to be as
> supported as a more straightforward raids+lvm2 scenario. But I might
> be willing to reconsider my position in light of such data losses.
>
>> no filesystem I know handles that without either going
>> readonly, or totally locking up.
>
> Which, to be fair, is exactly what I'm looking for. I'd rather see the
> filesystem lock itself up, until a human tries to restore the failed
> raid back online. But my recent experience and experiments show me
> that the filesystems actually don't lock themselves up, and don't go
> read only for quite some time, and heavy heavy data corruption will
> then happen. I'd be much more happy if the behavior was that the
> filesystem locks itself up instead of self destroying over time.
Hi Nicolas,

I have limited experience in that domain but I've usually observed that 
if the filesystem (say xfs) is unable to read or write its superblock it 
immediately goes into read only mode. MD will remain online and provide 
"best service" whenever possible, but as you pointed out this can be 
risky if you still think your RAID offers parity protection while 
degraded. I think in your case you're better off stopping an array that 
has less than parity drives than it should, either using a udev rule or 
using mdadm --monitor.

Regards,
Ben.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

