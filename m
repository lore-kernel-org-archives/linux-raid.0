Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351E5C61DA4
	for <linux-raid@archiver.kernel.org>; Wed, 15 Mar 2023 18:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjCOSG6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Mar 2023 14:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbjCOSG4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Mar 2023 14:06:56 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A135274337
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 11:06:54 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id y5so4113111ybu.3
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 11:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vastdata.com; s=google; t=1678903613;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d7TtwgjHlvnCvhBAybk3LTUO59A3lWQALBxnu6EH5DQ=;
        b=Qw5t9WDNmIIA32MKP+V/QrwJWRa1U7vuhLBUcPMJuuvq1dCM8zqJI2gbdsaQS94BH/
         hWv/z4AfBvLZ5IC3TGq5b8Rzh/UaP0AsSqLVrodFQblUfjPpugxkbwimYZnuBHUeP5Ph
         kM6nKR+05t/cshuV0xwEQmD9fdVspPyq4iJBH9i+MYmdSzoZDXL0Y0HGCE3p32As9X8D
         e8QLoQipfQ5J0C17cI6JgAQtm8Wufd7qoTsZNTEHx8ZWUWDljz0SvU6MYBnOp4wKFxb6
         HURDFoQrP3rNXOCpfsmid4jMCo3+aiofpAD/RKiRw948uGZyxDRMa/2gGc6aL2pOsp/r
         oLlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678903613;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d7TtwgjHlvnCvhBAybk3LTUO59A3lWQALBxnu6EH5DQ=;
        b=zkDK5PwphxuDkxA1UJXz60Ns+HzHZy58jJMBLIs+VcbxA4X48ydfxhYZBE6Fm2dkv7
         YjnYV4AwcLs7Jojvc0D47DTsN9eRidKzV56OlOcVPC00xU7rCeUsr9T0n1mV93zgBy3g
         eD8C84hPNeS3w2ZQVUUsCHO6b3ceHAXk/i/kRHF1jpJDr72No+I8ix0OVg7jgOqBdvUc
         fvWsGs50dvaiKc83uROX1JntS6gfrw672krZhAMlllvc5a5VFBF3aXIsJdu9w2aCYXqU
         gsb23rFI1YXnt5GpmA2aZISVa6HI9cDavz6bbwhPevg/0zMkjMNYa5VIHChYIRUDrg1I
         xGIg==
X-Gm-Message-State: AO0yUKXjnbgHUXKw3TX94GU5Zl0XQEYrb53MRjIUUGbRYtp2Ut0dZrxd
        JH0R0fUhe1tPgazZNYtUcgRHg8jqHZW6pfSd6AmtcP+a/ffv8ev+xeQ=
X-Google-Smtp-Source: AK7set8Jb3ix/XydRe3WFPiq0d/A9K1PKqtbCYeCpPw1fvWob9zOOcMJ4PaaY5PkNMQy9Hr5UbpKrIEE0wQNGG0+01k=
X-Received: by 2002:a05:6902:282:b0:a02:a3a6:7a67 with SMTP id
 v2-20020a056902028200b00a02a3a67a67mr26566741ybh.11.1678903613681; Wed, 15
 Mar 2023 11:06:53 -0700 (PDT)
MIME-Version: 1.0
From:   Ronnie Lazar <ronnie.lazar@vastdata.com>
Date:   Wed, 15 Mar 2023 20:06:42 +0200
Message-ID: <CALM_6_s7=eyDWFkirzg6ifqeeeF6-bnZD8n7=3=V+fm_qc34AQ@mail.gmail.com>
Subject: Question about potential data consistency issues when writes failed
 in mdadm raid1
To:     linux-raid@vger.kernel.org
Cc:     Asaf Levy <asaf@vastdata.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

I'm trying to understand how mdadm protects against inconsistent data
read in the face of failures that occur while writing to a device that
has raid1.
Here is the scenario:
I have set up raid1 that has 2 mirrors. First one is on local storage
and the second is on remote storage.  The remote storage mirror is
configured with write-mostly.

We have parallel jobs: 1 writing to an area on the device and the
other reading from that area.
The write operation writes the data to the first mirror, and at that
point the read operation reads the new data from the first mirror.
Now, before data has been written to the second (remote) mirror a
failure has occurred which caused the first machine to fail, When the
machine comes up, the data is recovered from the second, remote,
mirror.

Now when reading from this area, the users will receive the older
value, even though, in the first read they got the newer value that
was written.

Does mdadm protect against this inconsistency?

Regards,
Ronnie Lazar
