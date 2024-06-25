Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AEB25774
	for <linux-raid@vger.kernel.org>; Tue, 25 Jun 2024 02:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719283800; cv=none; b=YLLEYcmcj3pzN8dhmybPo0QaXl/XhSfyIE6G0HrNLw81q3gf1mJPFmDNVXCQqo/N5j8Sb0oSbxxDhAxeOeHPtYIbsjRWXxijVJtNlF5jagNB9KCokuL2YFIYPXAM2naFaSjhDoO/J8f+bhRpigDcolCsWx+4rp5qkHID3mXeDuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719283800; c=relaxed/simple;
	bh=xv2+0h85biNoNSYCQUqWZcMrP73hXLhSP6OcwpfbOl4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sh3hdAkH8+y/H4O4LjRZIiUAf7KmFuSPrxzfiLARGT2YUWHOQ0dCSPQ/f/IjCp7MGs7hcDPI2SPzyapfrVzWJBasiIocxqNZkChqYwYC1asEp0jZXVCd+TkNSxbNNS4UJV71qJQkAtnmXrzG04qxqWmrrlclk6OLZWpZ0nid4vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RbmCpDq/; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RbmCpDq/"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2eaafda3b5cso53191751fa.3
        for <linux-raid@vger.kernel.org>; Mon, 24 Jun 2024 19:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719283796; x=1719888596; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r+1AQ9RxKICKHFUFDTwlH+mU6qN3phqYDmfwgpyEDQk=;
        b=RbmCpDq/pEDa2dsMYpDqwWsyxzPxyUmraJ2WqVR1pdChfFpIaoM3AxYLxrj/ORN1Ra
         /8i00gTFYc7wNFQj0k3iaUrIaJxsjkHNAn2lA39RDT+0knVvaSHSU7f5+87a7/JOMb2X
         tcOdZBqb/yrx/RiHDnyLE+T5moc7/NnXnu3TiJS0GdN5NaoUQ53qZ3tpicMR+SBtgaEU
         /0zESGvKFMGmC585CzrT5f0Ip6wNM6Y+kLKbsVq/vSSU+QxpdNQBvtDZQBv/LYxUQNhy
         vpQ5Ig7CfhxwuFnxqR3CfkdRBcOmi6ZwCSSlikBNSlNJXzmFtFh/1J8edEIzNk1r3BwY
         g2bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719283796; x=1719888596;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r+1AQ9RxKICKHFUFDTwlH+mU6qN3phqYDmfwgpyEDQk=;
        b=Q9H1Wr5y//9hUH0j+TLCCvkOv6KTQ4G7JcgXxZ14RsjreWx63fIBxxY4j4jMauUpy3
         Und2mdWt13oPHR+ynRjCb9sUJVx5JA6f6vwBrsFlw575pL85cir90th9kbLMWbVwWO+1
         V42cec/3B4NztSGBPUrIId5g9zOfzYb30oDUgYnUddw/uyWekgJWJuEu9812D3Mu9jnG
         ExkWehliOFJwv//E1yvJBejlSBJztsBISFJo3HqggRykzrHUC8yQI3UfDRW5Cw2TAnJY
         y0mWiXKTCqI0JJoDdv03VprvtJoEzQAbPnEj6Wi8oyg1YKUzcDVyquOCeuJ03wMIb5ud
         +lcw==
X-Forwarded-Encrypted: i=1; AJvYcCWkyjZoUdiekQFyg9hUTcjRspKCnvblaoZ5gXhL9pzX9iAlairlk0AjZv01IN5j5MDhVsJxdyhkBr9VtD+wRySWSMQE6oM4N/xCkA==
X-Gm-Message-State: AOJu0Yw5NKdczn0xQ5vKHoCXk9UKtqIXAclhVOPuu4XG9Kgrhu3tE4ZW
	mxTgGur2HuV88yVWyyJhlYSkqb3UectqfC5TLLzHyHVziH3Suf9wr8jY9gwGLQ8=
X-Google-Smtp-Source: AGHT+IHWTg+RlEfwnhnTP2wbYmxAc5wYuMMrH+wES9wCXb/Y3e53vxkpc82XOVQxOkKgZm4ZOFVpgQ==
X-Received: by 2002:a2e:9f57:0:b0:2ea:91cf:a5f0 with SMTP id 38308e7fff4ca-2ec593d97c9mr38869291fa.19.1719283795960;
        Mon, 24 Jun 2024 19:49:55 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c819dbcc86sm7471988a91.42.2024.06.24.19.49.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jun 2024 19:49:55 -0700 (PDT)
Message-ID: <b6b043fa-b427-418b-87b2-ffbf4d5e5a76@suse.com>
Date: Tue, 25 Jun 2024 10:49:50 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] md-cluster: fix hanging issue while a new disk adding
To: Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org, xni@redhat.com
Cc: glass.su@suse.com, linux-raid@vger.kernel.org, colyli@suse.de,
 "yukuai (C)" <yukuai3@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <20240612021911.11043-1-heming.zhao@suse.com>
 <683d0326-c67b-4273-b19c-8cb39b28e736@suse.com>
 <864cf5a9-cdc6-4968-8fba-2e93a221f8de@huaweicloud.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <864cf5a9-cdc6-4968-8fba-2e93a221f8de@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/24/24 10:37, Yu Kuai wrote:
> Hi,
> 
> 在 2024/06/24 9:55, Heming Zhao 写道:
>> Hello Song & Kuai,
>>
>> Xiao ni told me that he has been quite busy recently and cannot review
>> the code. Do you have time to review my code?
>>
>> btw,
>> The patches has been passed the 60 loops of clustermd_tests [1]. because
>> the kernel md layer code changes, the clustermd_tests scripts also need
>> to be updated. I will send the clustermd_tests patch when the kernel
>> layer code passes review.
> 
> The tests will be quite important, since I'm not familiar with cluster
> code here. Of coure I'll find sometime to review the code.
> 
> Thanks,
> Kuai
> 

Thanks for your reply. I post the set up for HA env here, if you have any
question please feel free to ask me.

--------
# How to set up clustered md env

(I use opensuse tumbleweed to test)

1. cook the patches

[PATCH 1/2] mdadm/clustermd_tests: add some apis in func.sh to support test to run without error
[PATCH 2/2] mdadm/clustermd_tests: adjust test cases to support md module changes
- https://lore.kernel.org/linux-raid/20240625021019.8732-1-heming.zhao@suse.com/T/#t

2. edit mdadm.git/clustermd_tests/cluster_conf

2.1 edit NODE[12], e.g:

```
NODE1=192.168.1.100
NODE2=192.168.1.101
```

2.2 edit 'devlist=', e.g:

```
devlist=/dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
```

in my env, each sd[abcdef] size is 300MB

3. set up cluster env

download ISO:
https://mirrors.tuna.tsinghua.edu.cn/opensuse/tumbleweed/iso/openSUSE-Tumbleweed-DVD-x86_64-Snapshot20240621-Media.iso

install two VMs. add 6 shared disk (each 300MB), the backend is raw file.

4. set up ha

4.1 install softwares

because tumbleweed doesn't support "zypper -t pattern" mode to install HA stack softwares.

install HA stack command from opensuse:
  zypper in crmsh pacemaker corosync libcsync-plugin-sftp libvirt-client

4.2 set up ha

ref: https://documentation.suse.com/sle-ha/15-SP5/html/SLE-HA-all/article-installation.html

set up vm machine hostname:
node1: hostnamectl set-hostname tw-md1
node2: hostnamectl set-hostname tw-md2

edit /etc/hosts:
192.168.111.100 tw-md1
192.168.111.101 tw-md2

copy to another node:
scp -O /etc/hosts tw-md2:/etc/


on node1:
crm cluster init -S -y -i <node1-ip>

on node2:
crm cluster join -c <node1-ip>

on node1:
crm config edit (<== edit config as following)

```
INFO: "config" is accepted as "configure"
node 1: tw-md1
node 2: tw-md2
primitive dlm ocf:pacemaker:controld \
         op monitor interval=60s timeout=60s \
         op stop timeout=100s interval=0s \
         op monitor interval=30s timeout=90s
primitive stonith-libvirt stonith:external/libvirt \
         params hostlist="tb-md1,tb-md2" hypervisor_uri="qemu+tcp://<host-ip>/system" pcmk_delay_max=30s
group base-group dlm
clone base-clone base-group \
         meta interleave=true
property cib-bootstrap-options: \
         have-watchdog=true \
         dc-version="2.1.7+20240530.09c4d6d2e-1.2-2.1.7+20240530.09c4d6d2e" \
         cluster-infrastructure=corosync \
         cluster-name=hacluster \
         stonith-timeout=71 \
         stonith-enabled=true \
         no-quorum-policy=freeze
rsc_defaults build-resource-defaults: \
         resource-stickiness=1 \
         priority=1
```

note:
- hypervisor_uri="qemu+tcp://<host-ip>/system", the <host-ip> should be
   adjusted according to the real env.
- use 'crm config show' to show/check the config

check HA status:

crm status full (<== should show no error, see below)

```
Node List:
   * Node tw-md1: online:
     * Resources:
       * stonith-libvirt (stonith:external/libvirt):      Started
       * dlm     (ocf:pacemaker:controld):        Started
   * Node tw-md2: online:
     * Resources:
       * dlm     (ocf:pacemaker:controld):        Started
```

5. run test

all:
./test --testdir=clustermd_tests --save-logs --logdir=./logs --keep-going

single test:
./test --testdir=clustermd_tests --save-logs --logdir=./logs --keep-going --tests=02r1_Manage_add

Thanks,
Heming

>>
>> [1]: https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/clustermd_tests
>>
>> Thanks,
>> Heming
>>
>> On 6/12/24 10:19, Heming Zhao wrote:
>>> The commit 1bbe254e4336 ("md-cluster: check for timeout while a
>>> new disk adding") is correct in terms of code syntax but not
>>> suite real clustered code logic.
>>>
>>> When a timeout occurs while adding a new disk, if recv_daemon()
>>> bypasses the unlock for ack_lockres:CR, another node will be waiting
>>> to grab EX lock. This will cause the cluster to hang indefinitely.
>>>
>>> How to fix:
>>>
>>> 1. In dlm_lock_sync(), change the wait behaviour from forever to a
>>>     timeout, This could avoid the hanging issue when another node
>>>     fails to handle cluster msg. Another result of this change is
>>>     that if another node receives an unknown msg (e.g. a new msg_type),
>>>     the old code will hang, whereas the new code will timeout and fail.
>>>     This could help cluster_md handle new msg_type from different
>>>     nodes with different kernel/module versions (e.g. The user only
>>>     updates one leg's kernel and monitors the stability of the new
>>>     kernel).
>>> 2. The old code for __sendmsg() always returns 0 (success) under the
>>>     design (must successfully unlock ->message_lockres). This commit
>>>     makes this function return an error number when an error occurs.
>>>
>>> Fixes: 1bbe254e4336 ("md-cluster: check for timeout while a new disk adding")
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>> Reviewed-by: Su Yue <glass.su@suse.com>
>>> ---
>>>   drivers/md/md-cluster.c | 14 ++++++++++++--
>>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>>> index 8e36a0feec09..27eaaf9fef94 100644
>>> --- a/drivers/md/md-cluster.c
>>> +++ b/drivers/md/md-cluster.c
>>> @@ -130,8 +130,13 @@ static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
>>>               0, sync_ast, res, res->bast);
>>>       if (ret)
>>>           return ret;
>>> -    wait_event(res->sync_locking, res->sync_locking_done);
>>> +    ret = wait_event_timeout(res->sync_locking, res->sync_locking_done,
>>> +                60 * HZ);
>>>       res->sync_locking_done = false;
>>> +    if (!ret) {
>>> +        pr_err("locking DLM '%s' timeout!\n", res->name);
>>> +        return -EBUSY;
>>> +    }
>>>       if (res->lksb.sb_status == 0)
>>>           res->mode = mode;
>>>       return res->lksb.sb_status;
>>> @@ -744,12 +749,14 @@ static void unlock_comm(struct md_cluster_info *cinfo)
>>>   static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>>   {
>>>       int error;
>>> +    int ret = 0;
>>>       int slot = cinfo->slot_number - 1;
>>>       cmsg->slot = cpu_to_le32(slot);
>>>       /*get EX on Message*/
>>>       error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_EX);
>>>       if (error) {
>>> +        ret = error;
>>>           pr_err("md-cluster: failed to get EX on MESSAGE (%d)\n", error);
>>>           goto failed_message;
>>>       }
>>> @@ -759,6 +766,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>>       /*down-convert EX to CW on Message*/
>>>       error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_CW);
>>>       if (error) {
>>> +        ret = error;
>>>           pr_err("md-cluster: failed to convert EX to CW on MESSAGE(%d)\n",
>>>                   error);
>>>           goto failed_ack;
>>> @@ -767,6 +775,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>>       /*up-convert CR to EX on Ack*/
>>>       error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_EX);
>>>       if (error) {
>>> +        ret = error;
>>>           pr_err("md-cluster: failed to convert CR to EX on ACK(%d)\n",
>>>                   error);
>>>           goto failed_ack;
>>> @@ -775,6 +784,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>>       /*down-convert EX to CR on Ack*/
>>>       error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR);
>>>       if (error) {
>>> +        ret = error;
>>>           pr_err("md-cluster: failed to convert EX to CR on ACK(%d)\n",
>>>                   error);
>>>           goto failed_ack;
>>> @@ -789,7 +799,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
>>>           goto failed_ack;
>>>       }
>>>   failed_message:
>>> -    return error;
>>> +    return ret;
>>>   }
>>>   static int sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg,
>>
>>
>> .
>>
> 

