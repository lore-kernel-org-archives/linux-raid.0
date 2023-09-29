Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D468E728DD
	for <linux-raid@archiver.kernel.org>; Fri, 29 Sep 2023 19:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbjI2ToX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 29 Sep 2023 15:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbjI2ToW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 29 Sep 2023 15:44:22 -0400
Received: from micaiah.parthemores.com (micaiah.parthemores.com [199.26.172.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B502113
        for <linux-raid@vger.kernel.org>; Fri, 29 Sep 2023 12:44:16 -0700 (PDT)
Received: from [192.168.50.173] (h-155-4-132-6.NA.cust.bahnhof.se [155.4.132.6])
        by micaiah.parthemores.com (Postfix) with ESMTPSA id 169D630072A;
        Fri, 29 Sep 2023 21:43:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parthemores.com;
        s=micaiah; t=1696016592;
        bh=l+yoQXR3pyqdAGU6lKv0c39JBnd0Kyn6KeE/wJMiaes=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=p7QfmcDg5cMtFklvkeiKlt9qU4T5jUuvhcsXRkzcMzU0OrNajUMB7CyKMtfLiJTj4
         7ogEQXP7XUSJgXpd8N+y9NDieQXAL2gQ8t4zG47gs7SnksrIPC2qMfPjg1GEkiG3Ay
         dOIilxlKQ3L0O2wFPPzmy3K+kTDR4Gw/DUi58kU0=
Message-ID: <9c67d4b6-9b7d-467c-827a-729f62348d54@parthemores.com>
Date:   Fri, 29 Sep 2023 21:44:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: request for help on IMSM-metadata RAID-5 array
Content-Language: sv-FI
To:     Yu Kuai <yukuai1@huaweicloud.com>, Roman Mamedov <rm@romanrm.net>
Cc:     linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <507b6ab0-fd8f-d770-ba82-28def5f53d25@parthemores.com>
 <20230923162449.3ea0d586@nvm>
 <4095b51a-1038-2fd0-6503-64c0daa913d8@parthemores.com>
 <20230923203512.581fcd7d@nvm>
 <72388663-3997-a410-76f0-066dcd7d2a63@parthemores.com>
 <4d606b3d-ccec-e791-97ba-2cb5af0cc226@huaweicloud.com>
 <02a12a6d-eac4-51a1-e5ab-3df4d79bb87b@parthemores.com>
 <86dd0750-d060-eada-dc16-03a783c3bd1d@huaweicloud.com>
From:   Joel Parthemore <joel@parthemores.com>
In-Reply-To: <86dd0750-d060-eada-dc16-03a783c3bd1d@huaweicloud.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms090201060900060407090201"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090201060900060407090201
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Den 2023-09-26 kl. 03:10, skrev Yu Kuai:


>>> It'll be much helper for developers to collect kernel stack for all 
>>> stuck thread(and it'll be much better to use add2line).
>>
>>
>> Presuming I can re-create the problem, let me know what I should do 
>> to collect that information for you. I'm very much a newbie in that 
>> area.
>
> You can use following cmd:
>
> for pid in `ps -elf | grep " D " | awk '{print $4}'`; do ps $pid; cat 
> /proc/$pid/stack; done
>
> Thanks,
> Kuai


for pid in `ps -elf | grep " D " | awk '{print $4}'`; do ps $pid; cat 
/proc/$pid/stack; done
   PID TTY      STAT   TIME COMMAND
  4017 tty1     D+     0:00 e2fsck /dev/md126
[<0>] md_write_start+0x191/0x310
[<0>] raid5_make_request+0x90/0x1230 [raid456]
[<0>] md_handle_request+0x129/0x210
[<0>] __submit_bio+0x7f/0x110
[<0>] submit_bio_noacct_nocheck+0x150/0x360
[<0>] __block_write_full_folio+0x1d8/0x3f0
[<0>] writepage_cb+0x11/0x70
[<0>] write_cache_pages+0x13a/0x390
[<0>] do_writepages+0x15b/0x1e0
[<0>] filemap_fdatawrite_wbc+0x5a/0x80
[<0>] __filemap_fdatawrite_range+0x53/0x80
[<0>] filemap_write_and_wait_range+0x3a/0xa0
[<0>] blkdev_put+0x116/0x1c0
[<0>] blkdev_release+0x22/0x30
[<0>] __fput+0xe5/0x290
[<0>] task_work_run+0x51/0x80
[<0>] exit_to_user_mode_prepare+0x132/0x140
[<0>] syscall_exit_to_user_mode+0x1d/0x50
[<0>] do_syscall_64+0x46/0x90
[<0>] entry_SYSCALL_64_after_hwframe+0x6e/0xd8
   PID TTY      STAT   TIME COMMAND
cat: /proc/5266/stack: Filen eller katalogen finns inte


-- 
---------------------------------------------------------------
- Joel Parthemore - philosopher - academic proofreader --------
- English teacher - technology instructor - editor ------------
- "We are all in the gutter, but some of us are looking at the-
- "stars." - Oscar Wilde --------------------------------------
---------------------------------------------------------------


--------------ms090201060900060407090201
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME-kryptografisk signatur

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
Cy4wggUWMIID/qADAgECAhEAmVo2iRQf22NMTUenla48RjANBgkqhkiG9w0BAQsFADCBljEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBD
bGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTAeFw0yMjA5MjUwMDAw
MDBaFw0yNTA5MjQyMzU5NTlaMCUxIzAhBgkqhkiG9w0BCQEWFGpvZWxAcGFydGhlbW9yZXMu
Y29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtpEnoXLObjkdesO7Pw89lb41
PbrwWWtGQZ/Wbn9Rvh3FEO+QZkaW3BeVtH/sRwTcuNscn30bdB1TVMLJAFv7De6jEBvryywG
qRsJ1/wSvFKgdfNzUgBLP2AsAI9eTeKZWlJrMeVSQMh6UQo+Im11n5VQCdar/0Q+mTTXIGtU
5xHEvobZHxYCbsD+a7HMcRsLEdbnpoittGGAdwl/OH0SsDfntxTWSrgP7JFobgu+wbOebL8n
h45k0htK9SFeLtGHLeNhDG76KBpGfYYw2QUNekvM/7kAMIDZZrZGBzWq6lDIA6pt//5o1do0
ilK42V9i42eOnxPwYpGYc/kcGYNCLwIDAQABo4IBzTCCAckwHwYDVR0jBBgwFoAUCcDy/Ava
lNtf/ivfqJlCz8ngrQAwHQYDVR0OBBYEFBB5KVhhU3BbTO+5P+sLHjNoydT9MA4GA1UdDwEB
/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUFBwMEBggrBgEFBQcDAjBA
BgNVHSAEOTA3MDUGDCsGAQQBsjEBAgEBATAlMCMGCCsGAQUFBwIBFhdodHRwczovL3NlY3Rp
Z28uY29tL0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLnNlY3RpZ28uY29tL1Nl
Y3RpZ29SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3JsMIGKBggr
BgEFBQcBAQR+MHwwVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuc2VjdGlnby5jb20vU2VjdGln
b1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwIwYIKwYBBQUH
MAGGF2h0dHA6Ly9vY3NwLnNlY3RpZ28uY29tMB8GA1UdEQQYMBaBFGpvZWxAcGFydGhlbW9y
ZXMuY29tMA0GCSqGSIb3DQEBCwUAA4IBAQCgtrEVtcDMmVcxNk3UUepnV8c1PCpxnUXyJkjd
+yYjt/jHzwanZZMN+KCA2yFgn4MNmaqohejX9gXJBSq3iVqMdOoG2aaGD5Q3sD2p38cLD1p0
ppurJPvlSk964wmHvrc6+Vm75h0sM2nE8THbN0ft2/WXwqkg79LrkZHLmZtGjs+oBDHGs1lZ
ABuTci48UGkWcpRehPJsYZjDJsiM72ASjVZzVa8SYikpafItb6P6lCSWPUQBOQACSsLtsaZa
XiW+bDAumriMVafcvEkcubpRwc1OwxcpRduKIhGdXVB9yNNZF/5si0/NjYNftsSYD8b7n0OH
cs9YeelX5NjconjPMIIGEDCCA/igAwIBAgIQTZQsENQ74JQJxYEtOisGTzANBgkqhkiG9w0B
AQwFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0pl
cnNleSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVT
RVJUcnVzdCBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTgxMTAyMDAwMDAwWhcN
MzAxMjMxMjM1OTU5WjCBljELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hl
c3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYD
VQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFp
bCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMo87ZQKQf/e+Ua56NY75tqS
vysQTqoavIK9viYcKSoq0s2cUIE/bZQu85eoZ9X140qOTKl1HyLTJbazGl6nBEibivHbSuej
Qkq6uIgymiqvTcTlxZql19szfBxxo0Nm9l79L9S+TZNTEDygNfcXlkHKRhBhVFHdJDfqB6Mf
i/Wlda43zYgo92yZOpCWjj2mz4tudN55/yE1+XvFnz5xsOFbme/SoY9WAa39uJORHtbC0x7C
7aYivToxuIkEQXaumf05Vcf4RgHs+Yd+mwSTManRy6XcCFJE6k/LHt3ndD3sA3If/JBz6OX2
ZebtQdHnKav7Azf+bAhudg7PkFOTuRMCAwEAAaOCAWQwggFgMB8GA1UdIwQYMBaAFFN5v1qq
K0rPVIDh2JvAnfKyA2bLMB0GA1UdDgQWBBQJwPL8C9qU21/+K9+omULPyeCtADAOBgNVHQ8B
Af8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYB
BQUHAwQwEQYDVR0gBAowCDAGBgRVHSAAMFAGA1UdHwRJMEcwRaBDoEGGP2h0dHA6Ly9jcmwu
dXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5LmNybDB2
BggrBgEFBQcBAQRqMGgwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNlcnRydXN0LmNvbS9V
U0VSVHJ1c3RSU0FBZGRUcnVzdENBLmNydDAlBggrBgEFBQcwAYYZaHR0cDovL29jc3AudXNl
cnRydXN0LmNvbTANBgkqhkiG9w0BAQwFAAOCAgEAQUR1AKs5whX13o6VbTJxaIwA3RfXehwQ
OJDI47G9FzGR87bjgrShfsbMIYdhqpFuSUKzPM1ZVPgNlT+9istp5UQNRsJiD4KLu+E2f102
qxxvM3TEoGg65FWM89YN5yFTvSB5PelcLGnCLwRfCX6iLPvGlh9j30lKzcT+mLO1NLGWMeK1
w+vnKhav2VuQVHwpTf64ZNnXUF8p+5JJpGtkUG/XfdJ5jR3YCq8H0OPZkNoVkDQ5CSSF8Co2
AOlVEf32VBXglIrHQ3v9AAS0yPo4Xl1FdXqGFe5TcDQSqXh3TbjugGnG+d9yZX3lB8bwc/Tn
2FlIl7tPbDAL4jNdUNA7jGee+tAnTtlZ6bFz+CsWmCIb6j6lDFqkXVsp+3KyLTZGXq6F2nnB
tN4t5jO3ZIj2gpIKHAYNBAWLG2Q2fG7Bt2tPC8BLC9WIM90gbMhAmtMGquITn/2fORdsNmaV
3z/sPKuIn8DvdEhmWVfh0fyYeqxGlTw0RfwhBlakdYYrkDmdWC+XszE19GUi8K8plBNKcIvy
g2omAdebrMIHiAHAOiczxX/aS5ABRVrNUDcjfvp4hYbDOO6qHcfzy/uY0fO5ssebmHQREJJA
3PpSgdVnLernF6pthJrGkNDPeUI05svqw1o5A2HcNzLOpklhNwZ+4uWYLcAi14ACHuVvJsmz
NicxggQ1MIIEMQIBATCBrDCBljELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFu
Y2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMT4w
PAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBF
bWFpbCBDQQIRAJlaNokUH9tjTE1Hp5WuPEYwDQYJYIZIAWUDBAIBBQCgggJZMBgGCSqGSIb3
DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDkyOTE5NDQwOVowLwYJKoZI
hvcNAQkEMSIEIAXEnKG41TGuGQ1nJdM2IN6CAVCc+O5om1uhcp5ZUgSfMGwGCSqGSIb3DQEJ
DzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0D
AgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQB
gjcQBDGBrzCBrDCBljELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3Rl
cjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQD
EzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBD
QQIRAJlaNokUH9tjTE1Hp5WuPEYwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGWMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgw
FgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBB
dXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAmVo2iRQf22NMTUenla48RjAN
BgkqhkiG9w0BAQEFAASCAQB4rdXD1WpUZXyR1L8DKUGlMGH1zhSeMZx+NgRaxn1UZJZjitX5
UKQpsDgosDGGnW2jR8QAhyNh0alSxptXY4ycHXDpR2YFYAJg0z3ZCJNyvz9fEFvgc7yhJm4r
IOP7F1L3DdmlbX0BscIM6t2K4GOJVWU2ShC3/cYUZmZee2MykSnPHj+G4XGjUGiAsYxC6oQW
pZ1bY/DR8K4byxey+K2kTFpyziT6sNLYhF1uyaR8ixCBr0eDxUDxkyXDMP1c22QZ9hfGNC3Q
yN/tLvvGPtxlNeMHnhWFxRw99KkQZrjOPKGuGqk/PyiboTAGeL8r6hQb58ShmV8w3R66Tc6y
UKF8AAAAAAAA
--------------ms090201060900060407090201--
