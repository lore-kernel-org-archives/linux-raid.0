Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FA3C433F5
	for <linux-raid@archiver.kernel.org>; Sat, 23 Oct 2021 18:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22E9A60E9C
	for <linux-raid@archiver.kernel.org>; Sat, 23 Oct 2021 18:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhJWSQw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 23 Oct 2021 14:16:52 -0400
Received: from outbound5a.eu.mailhop.org ([3.124.88.253]:31468 "EHLO
        outbound5a.eu.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhJWSQw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 23 Oct 2021 14:16:52 -0400
X-Greylist: delayed 1801 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Oct 2021 14:16:51 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1635010108; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=WeeSxxA9f8/9QQ9AIeTAh6MqzcFYP8Po6a8uj/WtPhj5JYPnvsgiAQ9YCbVleoSFwbllFUr4bGwKv
         Wo6Au5rdMzJ+/lD8iol5YHk8jogxTwsi03l2XZJQ7Tne4bR1fNVqAGkwzeKZV9inAmx+xupi5MM93t
         Xlw6rj7R2mJ5qukfRjKsvvlDxm+CVDBZ+dwtoOfuA+HSXW4fxISdfOpHmTGviEl5dbY+mu7pcwsPge
         topViqYTJzaWhraia2RzROQhkp9/xgqRX6UqND976OsnR3qI5JZQc98dNNH4Lw/IIOHIIdb0Slcqr8
         QrQzR8tI8z+65iEYnqFL4bymI68oQFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=content-transfer-encoding:content-type:to:subject:from:mime-version:date:
         message-id:dkim-signature:from;
        bh=pplGhr4ysJtC34uv3moXjIEk6xeBo+YDnTJuW2bS4SQ=;
        b=fH8YipLYw7lkxLqL+xTb43gpxRC8vSvjzUaxpg+yOYUZiB/CyGeljKPx9qSzDxtMYMDwTdFxaNf7L
         pZLxQD6MbBFo8tnVKKYqhx06gA3aUVu/wj1tiIboRyh6eToTfOrKcHJ+S3JaAHwsg18FxVOlvCOW0x
         R1WhyycYS7FlR98oqJB6TpQbwQgWY+zAhP0brUGs8Df2pD8bYEuijnXc0S3BrdOpIQR5sNBp8siy6M
         hY9iuPVxdKBoMDpVIcdV4pvczFRAYqDBAaJtKmj4KbUDfh24sAnRj6ItfSUX40Q+3mNAAA1kn+7CQu
         oy/n3rEZ5Q6ZtZ9CbeWKSx9bZgV7I9A==
ARC-Authentication-Results: i=1; outbound3.eu.mailhop.org;
        spf=none smtp.mailfrom=cas.homelinux.org smtp.remote-ip=72.83.183.41;
        dmarc=none header.from=cas.homelinux.org;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=content-transfer-encoding:content-type:to:subject:from:mime-version:date:
         message-id:from;
        bh=pplGhr4ysJtC34uv3moXjIEk6xeBo+YDnTJuW2bS4SQ=;
        b=s1TK4scKhAtbgJT7u3VedsjKjlQhKPx+heZNvRsBvYJR7FYZyLzxCZTRrxO/JmRqVJ41iZK899InO
         bIPIJU4xsFKbXHJBYDWOfWKuJwh+og3Xw9Xiz19p7RyH+7abRugjIjNWoiw+WuyRI05mUUf/dv7JAS
         6MATtM5IjQVonWQ/3YcIXekfGVVV6nkbRL+zIMXeQqjqvDgI/d3qZZ+ASRxmP39/RWH7y70JALM5Bx
         uyQrCt5Xh8+KjVn2s7rugc/SkTf21J2CXtbveDxD1zc4xsQuYn8CQr1nvK83zRWFW8SvMxqhggtOQd
         iN04vOnKINTNzTcTmcIw4e8WYETrJmg==
X-Originating-IP: 72.83.183.41
X-MHO-RoutePath: Y3NjaGFuemxl
X-MHO-User: a15d70ed-3426-11ec-a40e-d17a12b91375
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from [192.168.4.59] (pool-72-83-183-41.washdc.fios.verizon.net [72.83.183.41])
        by outbound3.eu.mailhop.org (Halon) with ESMTPSA
        id a15d70ed-3426-11ec-a40e-d17a12b91375;
        Sat, 23 Oct 2021 17:28:26 +0000 (UTC)
Message-ID: <d2daf328-69ab-c540-aaf3-97e4a6ea4355@cas.homelinux.org>
Date:   Sat, 23 Oct 2021 13:28:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
From:   Chris Schanzle <mdadm@cas.homelinux.org>
Subject: Inconsistent device numbers after reboot
To:     linux-raid <linux-raid@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The device ID of my partition containing my home directory changes (sometimes) when I reboot, typically after kernel updates. Sometimes subsequent reboots with the same kernel change it again, but typically after that it is usually consistent.

Changing device ID's causes havoc with tar incremental backups - tar consider all files are new.

Is there something I can change to keep st_dev static?

I'm running Fedora 33 with my home filesystem as XFS on a LVM supported by md RAID1.

I'm not sure if this is caused by LVM or md or something else, hence I ask the experts here.

I have a cron job logging the device ID of my home directory at boot with the kernel version, included below.

Any thoughts would be appreciated!  Thanks in advance.

2021-02-20 22:47 fd03h/64771d 5.10.16-200.fc33.x86_64
2021-02-25 12:59 fd03h/64771d 5.10.17-200.fc33.x86_64
2021-02-27 22:49 fd03h/64771d 5.10.18-200.fc33.x86_64
2021-03-03 12:11 fd04h/64772d 5.10.19-200.fc33.x86_64
2021-03-12 16:25 fd03h/64771d 5.10.21-200.fc33.x86_64
2021-03-16 22:55 fd06h/64774d 5.10.22-200.fc33.x86_64
2021-03-19 14:00 fd06h/64774d 5.10.23-200.fc33.x86_64
2021-03-23 09:35 fd06h/64774d 5.11.7-200.fc33.x86_64
2021-03-28 11:24 fd04h/64772d 5.11.10-200.fc33.x86_64
2021-03-30 17:26 fd06h/64774d 5.11.10-200.fc33.x86_64
2021-04-02 20:11 fd03h/64771d 5.11.11-200.fc33.x86_64
2021-04-14 17:41 fd06h/64774d 5.11.12-200.fc33.x86_64
2021-04-16 17:37 fd06h/64774d 5.11.13-200.fc33.x86_64
2021-04-18 11:58 fd03h/64771d 5.11.14-200.fc33.x86_64
2021-04-22 01:34 fd03h/64771d 5.11.15-200.fc33.x86_64
2021-04-22 01:41 fd06h/64774d 5.11.15-200.fc33.x86_64
2021-04-22 01:42 fd06h/64774d 5.11.15-200.fc33.x86_64
2021-04-22 01:43 fd06h/64774d 5.11.15-200.fc33.x86_64
2021-04-22 01:44 fd06h/64774d 5.11.15-200.fc33.x86_64
2021-04-22 01:45 fd06h/64774d 5.11.15-200.fc33.x86_64
2021-04-22 01:46 fd06h/64774d 5.11.15-200.fc33.x86_64
2021-04-22 01:47 fd06h/64774d 5.11.15-200.fc33.x86_64
2021-04-27 15:18 fd03h/64771d 5.11.16-200.fc33.x86_64
2021-04-28 21:10 fd03h/64771d 5.11.16-200.fc33.x86_64
2021-04-28 21:11 fd06h/64774d 5.11.16-200.fc33.x86_64
2021-04-28 21:12 fd06h/64774d 5.11.16-200.fc33.x86_64
2021-04-28 21:13 fd06h/64774d 5.11.16-200.fc33.x86_64
2021-04-28 21:14 fd06h/64774d 5.11.16-200.fc33.x86_64
2021-05-03 19:23 fd03h/64771d 5.11.17-200.fc33.x86_64
2021-05-08 10:43 fd03h/64771d 5.11.17-200.fc33.x86_64
2021-05-08 10:44 fd06h/64774d 5.11.17-200.fc33.x86_64
2021-05-08 10:45 fd06h/64774d 5.11.17-200.fc33.x86_64
2021-05-08 10:46 fd06h/64774d 5.11.17-200.fc33.x86_64
2021-05-08 10:46 fd06h/64774d 5.11.17-200.fc33.x86_64
2021-05-08 10:48 fd06h/64774d 5.11.17-200.fc33.x86_64
2021-05-11 01:28 fd06h/64774d 5.11.18-200.fc33.x86_64
2021-05-14 22:51 fd03h/64771d 5.11.19-200.fc33.x86_64
2021-05-16 12:52 fd03h/64771d 5.11.20-200.fc33.x86_64
2021-05-16 12:53 fd05h/64773d 5.11.20-200.fc33.x86_64
2021-05-16 12:54 fd04h/64772d 5.11.20-200.fc33.x86_64
2021-05-16 12:55 fd06h/64774d 5.11.20-200.fc33.x86_64
2021-05-16 12:56 fd03h/64771d 5.11.20-200.fc33.x86_64
2021-05-16 12:57 fd05h/64773d 5.11.20-200.fc33.x86_64
2021-05-16 12:58 fd03h/64771d 5.11.20-200.fc33.x86_64
2021-05-16 12:58 fd03h/64771d 5.11.20-200.fc33.x86_64
2021-05-16 12:59 fd03h/64771d 5.11.20-200.fc33.x86_64
2021-05-16 13:01 fd03h/64771d 5.11.20-200.fc33.x86_64
2021-05-20 23:14 fd03h/64771d 5.11.21-200.fc33.x86_64
2021-05-30 22:16 fd06h/64774d 5.11.21-200.fc33.x86_64
2021-06-03 22:19 fd03h/64771d 5.11.21-200.fc33.x86_64
2021-06-03 22:36 fd06h/64774d 5.11.21-200.fc33.x86_64
2021-06-05 14:00 fd03h/64771d 5.11.21-200.fc33.x86_64
2021-06-20 22:32 fd03h/64771d 5.11.21-200.fc33.x86_64
2021-07-05 18:47 fd03h/64771d 5.11.21-200.fc33.x86_64
2021-07-28 17:53 fd03h/64771d 5.13.4-100.fc33.x86_64
2021-08-02 16:05 fd03h/64771d 5.13.4-100.fc33.x86_64
2021-08-02 16:30 fd03h/64771d 5.13.4-100.fc33.x86_64
2021-08-10 08:31 fd06h/64774d 5.13.8-100.fc33.x86_64
2021-08-18 21:13 fd03h/64771d 5.13.10-100.fc33.x86_64
2021-08-22 00:17 fd03h/64771d 5.13.12-100.fc33.x86_64
2021-09-16 07:04 fd06h/64774d 5.13.12-100.fc33.x86_64
2021-09-16 07:27 fd06h/64774d 5.13.15-100.fc33.x86_64
2021-09-25 12:41 fd03h/64771d 5.13.16-100.fc33.x86_64
2021-10-06 14:34 fd06h/64774d 5.14.9-100.fc33.x86_64
2021-10-06 14:35 fd06h/64774d 5.14.9-100.fc33.x86_64
2021-10-06 14:37 fd06h/64774d 5.14.9-100.fc33.x86_64
2021-10-16 10:59 fd06h/64774d 5.14.11-100.fc33.x86_64
2021-10-19 14:54 fd03h/64771d 5.14.12-100.fc33.x86_64
2021-10-19 14:57 fd03h/64771d 5.14.12-100.fc33.x86_64
2021-10-19 15:00 fd03h/64771d 5.14.12-100.fc33.x86_64
2021-10-19 15:02 fd03h/64771d 5.14.12-100.fc33.x86_64
2021-10-22 11:44 fd03h/64771d 5.14.12-100.fc33.x86_64



