From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: mdadm: /dev/sda1 is too small: 0K
Date: Sat, 13 Oct 2007 15:10:15 -0700
Message-ID: <e9c3a7c20710131510w3373325eob46070985cd71875@mail.gmail.com>
References: <63856.10.4.0.1.1192300390.squirrel@www.greeley.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <63856.10.4.0.1.1192300390.squirrel@www.greeley.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Hod Greeley <hod-lrvko@greeley.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/13/07, Hod Greeley <hod-lrvko@greeley.org> wrote:
> Hello,
>
> I tried to create a raid device starting with
>
> foo:~ 1032% mdadm --create -l1 -n2 /dev/md1 /dev/sda1 missing
> mdadm: /dev/sda1 is too small: 0K
> mdadm: create aborted
>

Quick sanity check, is /dev/sda1 still a block device node with major
number 8 and minor number 1, i.e. does the following fix the issue?:

mknod /dev/sda1 b 8 1

<snip>

> Thanks,
> Hod Greeley
>

--
Dan
