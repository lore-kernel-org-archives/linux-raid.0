From: Xiaosong Ma <xma@qf.org.qa>
Subject: Fwd: Fw: some questions about uploading a Linux kernel driver
Date: Wed, 22 Apr 2020 15:26:39 +0300
Message-ID: <CAKm37QWKVcPkF0fXKk2499CsYXfU3aMuMWgwa8Nk9HFzVxG7CA@mail.gmail.com>
References: <6a7c0aba219642de8b3f1cc680d53d85@AM0P193MB0754.EURP193.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6a7c0aba219642de8b3f1cc680d53d85@AM0P193MB0754.EURP193.PROD.OUTLOOK.COM>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org, linux-raid@vger.kernel.org
Cc: ty-jiang18@mails.tsinghua.edu.cn, Guangyan Zhang <gyzh@tsinghua.edu.cn>, wei-jy19@mails.tsinghua.edu.cn
List-Id: linux-raid.ids

Dear Song,

This is Xiaosong Ma from Qatar Computing Research Institute. I am
writing to follow up with the questions posed by a co-author from
Tsinghua U, regarding upstreaming our alternative md implementation
that is designed to significantly reduce SSD RAID latency (both median
and tail) for large SSD pools (such as 20-disk or more).

We read the Linux kernel upstreaming instructions, and believe that
our implementation has excellent separability from the current code
base (as a plug-and-play module with identical interfaces as md).
Meanwhile, we wonder whether there are standard test cases or
preferred applications that we should test our system with, before
doing code cleaning up. Your guidance is much appreciated.

Best regards,
Xiaosong

Dr. Xiaosong Ma
Principal Scientist
Distributed Systems

Qatar Computing Research Institute
Hamad Bin Khalifa University
HBKU – Research Complex
P.O. Box 5825
Doha, Qatar
Tel: +974 4454 6190
www.qcri.qa
<http://www.qcri.qa>



---------- Forwarded message ---------
From: 姜天洋 <ty-jiang18@mails.tsinghua.edu.cn>
Date: Tue, Apr 14, 2020 at 2:10 PM
Subject: Fw: some questions about uploading a Linux kernel driver
To: Dr. Xiaosong Ma <xma@hbku.edu.qa>, gyzh@tsinghua.edu.cn
<gyzh@tsinghua.edu.cn>, wei-jy19@mails.tsinghua.edu.cn
<wei-jy19@mails.tsinghua.edu.cn>





-----原始邮件-----
发件人:"姜天洋" <ty-jiang18@mails.tsinghua.edu.cn>
发送时间:2020-04-08 20:34:44 (星期三)
收件人: song@kernel.org
抄送: linux-raid@vger.kernel.org
主题: some questions about uploading a Linux kernel driver

Hello
I am Tianyang JIANG, a PhD student from Tsinghua U. We finish a study
which focuses on achieving consistent low latency for SSD arrays,
especially timing tail latency in RAID level. We implement a Linux
kernel driver called FusionRAID and we are interested in uploading
codes to Linux upstream.
I notice that I should seperate my changes and style-check my codes
before submitting. Are there any other issues I need to be aware of?
Thank you for your time.
