From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Data offset
Date: Thu, 15 May 2014 16:11:46 +0200
Message-ID: <CAAOsTSmQUzup9Oy1EZstEi-bqZPgYhuhT6upQsoEc7TXq7n3kg@mail.gmail.com>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have couple of questions regarding data offset:

- Current mdadm sets 128 MiB offset apparently for reshaping backup
file. Is it really used by reshape? From which kernel / mdadm version?

- Is there any other good reason for such big offset?

- Is there a support for specifying data offset when creating array?
In which version of mdadm? What are recommended lower values?

Thanks.

Patrik
