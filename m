From: "Hod Greeley" <hod-lrvko@greeley.org>
Subject: Re: mdadm: /dev/sda1 is too small: 0K
Date: Sat, 13 Oct 2007 19:59:08 -0700 (PDT)
Message-ID: <64282.10.4.0.1.1192330748.squirrel@www.greeley.org>
References: <63856.10.4.0.1.1192300390.squirrel@www.greeley.org>
    <e9c3a7c20710131510w3373325eob46070985cd71875@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20710131510w3373325eob46070985cd71875@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good catch.  /dev/sda1 was a scsi device in a former life.  Correcting
that fixed the problem.  Thanks!

Dan Williams wrote:
> On 10/13/07, Hod Greeley <hod-lrvko@greeley.org> wrote:
>> Hello,
>>
>> I tried to create a raid device starting with
>>
>> foo:~ 1032% mdadm --create -l1 -n2 /dev/md1 /dev/sda1 missing
>> mdadm: /dev/sda1 is too small: 0K
>> mdadm: create aborted
>>
>
> Quick sanity check, is /dev/sda1 still a block device node with major
> number 8 and minor number 1, i.e. does the following fix the issue?:
>
> mknod /dev/sda1 b 8 1
>
> <snip>
>
>> Thanks,
>> Hod Greeley
>>
>
> --
> Dan


