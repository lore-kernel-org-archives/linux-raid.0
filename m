From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH 1/2] uuid.c: split uuid stuffs from util.c
Date: Mon, 18 May 2020 13:18:17 -0400
Message-ID: <c06c34ec-c3f7-7abb-c1eb-642c52b04d63@trained-monkey.org>
References: <20200515134026.8084-1-guoqing.jiang@cloud.ionos.com>
 <20200515134026.8084-2-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200515134026.8084-2-guoqing.jiang@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: linux-raid@vger.kernel.org, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Wolfgang Denk <wd@denx.de>
List-Id: linux-raid.ids

On 5/15/20 9:40 AM, Guoqing Jiang wrote:
> Currently, 'make raid6check' is build broken since commit b06815989
> ("mdadm: load default sysfs attributes after assemblation").
> 
> /usr/bin/ld: sysfs.o: in function `sysfsline':
> sysfs.c:(.text+0x2707): undefined reference to `parse_uuid'
> /usr/bin/ld: sysfs.c:(.text+0x271a): undefined reference to `uuid_zero'
> /usr/bin/ld: sysfs.c:(.text+0x2721): undefined reference to `uuid_zero'
> 
> Apparently, the compile of mdadm or raid6check are coupled with uuid
> functions inside util.c. However, we can't just add util.o to CHECK_OBJS
> which raid6check is needed, because it caused other worse problems.
> 
> So, let's introduce a uuid.c file which is indenpended file to fix the
> problem, all the contents are splitted from util.c.
> 
> Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
> Cc: Wolfgang Denk <wd@denx.de>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> ---
>  Makefile |  6 ++--
>  util.c   | 87 -----------------------------------------------------
>  uuid.c   | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 95 insertions(+), 90 deletions(-)
>  create mode 100644 uuid.c

I am fine with this change, but uuid.c needs to respect the license
header that was in util.c

Jes
