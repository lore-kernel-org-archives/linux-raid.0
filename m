Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B0B374C3
	for <linux-raid@vger.kernel.org>; Wed, 15 May 2024 03:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715743252; cv=none; b=AbJNd1qPpN0n2I3WZEZLLDxgpNZyacKw5V/8L3FDwX/HkQxgI/3dTXPCN9Az8mDZlcDBAoXLbmNVXbqBkEkSp389k0vhNnuafZODoZYrV84+gLfj82CJv1KH/3HaFeA1Ab4Hjakyoep1BWKxba51jpxAJiGCZxuI0VEjoXqJyww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715743252; c=relaxed/simple;
	bh=nlaUQy9leXG6lO2EPWSuHvyCNZogBJ1YQXsjeE8Cavs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hRn8JLfYo7EC9atuPeC+8igymCu5TRuhqIcBnDIEt874VNUz34kh9upM9F26L3H5Ba5LYm70Wq8Q1ufFuPN+fiANfmgEY8W8NKaxypRcSfF98KlDg8wFQcLVvxORKioQDyltmp/2i74E2AmOdp2OkySqcfMGAQfXc0pqdiMxSCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aBm6HNIA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aBm6HNIA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715743249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LMeFWHAOOAAVW+itJorzJ1jh+qcEV/aQNPtotvC44wA=;
	b=aBm6HNIALCFfgkvVkoKk1YRQF8kHjqpu50zfMQQsrahEg6eRE9v852FqRjRgP/HjBZMIs2
	PWcsn4pvqKUjkWFKcxF2rXQvZgfMn52AvN32dEVSAI4lOfyEWnJ/8NzjOOS7FAojcHGAVe
	Y5EVQ57Hy7JCNplQZw7u0EWxaXAaC/A=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-3SEfAsQwOsC0OTMDG7Q9LQ-1; Tue, 14 May 2024 23:20:47 -0400
X-MC-Unique: 3SEfAsQwOsC0OTMDG7Q9LQ-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2b33cce8cfaso6289662a91.3
        for <linux-raid@vger.kernel.org>; Tue, 14 May 2024 20:20:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715743246; x=1716348046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LMeFWHAOOAAVW+itJorzJ1jh+qcEV/aQNPtotvC44wA=;
        b=pGKrxBGyrcwnZc4kZJctPy7+MQpwvepsf1drYSIMs97h1Z6THj3aFvbVHQKFF6wgEH
         xqYf5+IcTWare6WpMZ8J8LPz010MenWi1B/MADnI3Yh3YOWpTCsFgAj2XjTA63HmeLqS
         rUiX9T3ODODYE0yjVd4CM3XJhLgJzUS5RYj89i92LfWBoa53v7Emxcgbh3JIO7nOaZXr
         X+IXDR/d4n+s0HnI9YKpJHhqHKgATjyWeHr5oYKUSZz54LyDa88bXOCqvRUD3hiDXZ2s
         hJ4Ps4+bD4bdrQzI1DFL4VHqEW/7TCOkFHRr471iIgRWCd7qhfVnrX0aTJWUAschJSi9
         jJjw==
X-Forwarded-Encrypted: i=1; AJvYcCWnkOBeS6IPBz/651j18jRxiDWEFzUaDqlOOv6U3ubp0nHSAOlVl2sl13UysZ2vvkXp95VxYbL8HI0PH36xbotC5HXAfOmoHRSsUg==
X-Gm-Message-State: AOJu0Yzbdtg5IL6XwYrqJ6VrHMaAR9sW34o15J42tjs0chiVwboc5NH5
	aKvxMb1d5Y9/e8Ete0dLLdsFZhCj2FpZPSTBSIXAW2KTiyQg4hl4L103wbFXmEhga5sjCKTgFBf
	DiaECM2zjPy6i0oIoTaiVbKNn77kySff6dvWmGOOFXekzKzbQCxjM5pircMeVpDDCZ4VfNVivoq
	EynqnV0Rz60RaA3p8DZt+czVt7+V8gjvyRJQ==
X-Received: by 2002:a17:90a:4c84:b0:2b6:3034:4ae6 with SMTP id 98e67ed59e1d1-2b6ccd93d4dmr16251736a91.33.1715743246046;
        Tue, 14 May 2024 20:20:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDaBnQHxXralMl4j5bGjRj9LzT1cJ3yz5dqOB+iGSQEfGjW8mf2INedOTvGSXgFZCjtq3J8C4VFsMMfaCf710=
X-Received: by 2002:a17:90a:4c84:b0:2b6:3034:4ae6 with SMTP id
 98e67ed59e1d1-2b6ccd93d4dmr16251724a91.33.1715743245489; Tue, 14 May 2024
 20:20:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240322115120.12325-1-blazej.kucman@intel.com> <20240322115120.12325-3-blazej.kucman@intel.com>
In-Reply-To: <20240322115120.12325-3-blazej.kucman@intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 15 May 2024 11:20:33 +0800
Message-ID: <CALTww2_=gHgut3M=q6SqjenG1oS3FAmG5N+FdQ0fahexZ39PSg@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] Add reading Opal NVMe encryption information
To: Blazej Kucman <blazej.kucman@intel.com>
Cc: mariusz.tkaczyk@linux.intel.com, jes@trained-monkey.org, 
	linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 22, 2024 at 7:52=E2=80=AFPM Blazej Kucman <blazej.kucman@intel.=
com> wrote:
>
> For NVMe devices with Opal support, encryption information, status and
> ability are determined based on Opal Level 0 discovery response. Technica=
l
> documentation used is given in the implementation.
>
> Ability in general describes what type of encryption is supported, Status
> describes in what state the disk with encryption support is. The current
> patch includes only the implementation of reading encryption information,
> functions will be used in one of the next patches.
>
> Motivation for adding this functionality is to block mixing of disks in
> IMSM arrays with encryption enabled and disabled. The main goal is to not
> allow stealing data by rebuilding array to not encrypted drive which can =
be
> read elsewhere.
>
> Value ENA_OTHER from enum encryption_ability will be used in the next
> patch.
>
> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
> ---
>  Makefile           |   4 +-
>  drive_encryption.c | 362 +++++++++++++++++++++++++++++++++++++++++++++
>  drive_encryption.h |  32 ++++
>  3 files changed, 396 insertions(+), 2 deletions(-)
>  create mode 100644 drive_encryption.c
>  create mode 100644 drive_encryption.h
>
> diff --git a/Makefile b/Makefile
> index cbdba49a..7c221a89 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -170,7 +170,7 @@ OBJS =3D mdadm.o config.o policy.o mdstat.o  ReadMe.o=
 uuid.o util.o maps.o lib.o u
>         mdopen.o super0.o super1.o super-ddf.o super-intel.o bitmap.o \
>         super-mbr.o super-gpt.o \
>         restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o xmalloc=
.o \
> -       platform-intel.o probe_roms.o crc32c.o
> +       platform-intel.o probe_roms.o crc32c.o drive_encryption.o
>
>  CHECK_OBJS =3D restripe.o uuid.o sysfs.o maps.o lib.o xmalloc.o dlink.o
>
> @@ -183,7 +183,7 @@ MON_OBJS =3D mdmon.o monitor.o managemon.o uuid.o uti=
l.o maps.o mdstat.o sysfs.o c
>         Kill.o sg_io.o dlink.o ReadMe.o super-intel.o \
>         super-mbr.o super-gpt.o \
>         super-ddf.o sha1.o crc32.o msg.o bitmap.o xmalloc.o \
> -       platform-intel.o probe_roms.o crc32c.o
> +       platform-intel.o probe_roms.o crc32c.o drive_encryption.o
>
>  MON_SRCS =3D $(patsubst %.o,%.c,$(MON_OBJS))
>
> diff --git a/drive_encryption.c b/drive_encryption.c
> new file mode 100644
> index 00000000..b44585a7
> --- /dev/null
> +++ b/drive_encryption.c
> @@ -0,0 +1,362 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Read encryption information for Opal and ATA devices.
> + *
> + * Copyright (C) 2024 Intel Corporation
> + *     Author: Blazej Kucman <blazej.kucman@intel.com>
> + */
> +
> +#include "mdadm.h"
> +
> +#include <asm/types.h>
> +#include <linux/nvme_ioctl.h>
> +#include "drive_encryption.h"
> +
> +/*
> + * Opal defines
> + * TCG Storage Opal SSC 2.01 chapter 3.3.3
> + * NVM ExpressTM Revision 1.4c, chapter 5
> + */
> +#define TCG_SECP_01 (0x01)
> +#define TCG_SECP_00 (0x00)
> +#define OPAL_DISCOVERY_COMID (0x0001)
> +#define OPAL_LOCKING_FEATURE (0x0002)
> +#define OPAL_IO_BUFFER_LEN 2048
> +#define OPAL_DISCOVERY_FEATURE_HEADER_LEN (4)
> +
> +/*
> + * NVMe defines
> + * NVM ExpressTM Revision 1.4c, chapter 5
> + */
> +#define NVME_SECURITY_RECV (0x82)
> +#define NVME_IDENTIFY (0x06)
> +#define NVME_IDENTIFY_RESPONSE_LEN 4096
> +#define NVME_OACS_BYTE_POSITION (256)
> +#define NVME_IDENTIFY_CONTROLLER_DATA (1)
> +
> +typedef enum drive_feature_support_status {
> +       /* Drive feature is supported. */
> +       DRIVE_FEAT_SUP_ST =3D 0,
> +       /* Drive feature is not supported. */
> +       DRIVE_FEAT_NOT_SUP_ST,
> +       /* Drive feature support check failed. */
> +       DRIVE_FEAT_CHECK_FAILED_ST
> +} drive_feat_sup_st;
> +
> +/* TCG Storage Opal SSC 2.01 chapter 3.1.1.3 */
> +typedef struct opal_locking_feature {
> +       /* feature header */
> +       __u16 feature_code;
> +       __u8 reserved : 4;
> +       __u8 version : 4;
> +       __u8 description_length;
> +       /* feature description */
> +       __u8 locking_supported : 1;
> +       __u8 locking_enabled : 1;
> +       __u8 locked : 1;
> +       __u8 media_encryption : 1;
> +       __u8 mbr_enabled : 1;
> +       __u8 mbr_done : 1;
> +       __u8 mbr_shadowing_not_supported : 1;
> +       __u8 hw_reset_for_dor_supported : 1;
> +       __u8 reserved1[11];
> +} __attribute__((__packed__)) opal_locking_feature_t;
> +
> +/* TCG Storage Opal SSC 2.01 chapter 3.1.1.1 */
> +typedef struct opal_level0_header {
> +       __u32 length;
> +       __u32 version;
> +       __u64 reserved;
> +       __u8 vendor_specific[32];
> +} opal_level0_header_t;
> +
> +/**
> + * NVM ExpressTM Revision 1.4c, Figure 249
> + * Structure specifies only OACS filed, which is needed in the current u=
se case.
> + */
> +typedef struct nvme_identify_ctrl {
> +       __u8 reserved[255];
> +       __u16 oacs;
> +       __u8 reserved2[3839];
> +} nvme_identify_ctrl_t;
> +
> +/* SCSI Primary Commands - 4 (SPC-4), Table 512 */
> +typedef struct supported_security_protocols {
> +       __u8  reserved[6];
> +       __u16 list_length;
> +       __u8  list[504];
> +} supported_security_protocols_t;
> +
> +/**
> + * get_opal_locking_feature_description() - get opal locking feature des=
cription.
> + * @response: response from Opal Discovery Level 0.
> + *
> + * Based on the documentation TCG Storage Opal SSC 2.01 chapter 3.1.1,
> + * a Locking feature is searched for in Opal Level 0 Discovery response.
> + *
> + * Return: if locking feature is found, pointer to struct %opal_locking_=
feature_t, NULL otherwise.
> + */
> +static opal_locking_feature_t *get_opal_locking_feature_description(__u8=
 *response)
> +{
> +       opal_level0_header_t *response_header =3D (opal_level0_header_t *=
)response;
> +       int features_length =3D __be32_to_cpu(response_header->length);
> +       int current_position =3D sizeof(*response_header);
> +
> +       while (current_position < features_length) {
> +               opal_locking_feature_t *feature;
> +
> +               feature =3D (opal_locking_feature_t *)(response + current=
_position);
> +
> +               if (__be16_to_cpu(feature->feature_code) =3D=3D OPAL_LOCK=
ING_FEATURE)
> +                       return feature;
> +
> +               current_position +=3D feature->description_length + OPAL_=
DISCOVERY_FEATURE_HEADER_LEN;
> +       }
> +
> +       return NULL;
> +}
> +
> +/**
> + * nvme_security_recv_ioctl() - nvme security receive ioctl.
> + * @disk_fd: a disk file descriptor.
> + * @sec_protocol: security protocol.
> + * @comm_id: command id.
> + * @response_buffer: response buffer to fill out.
> + * @buf_size: response buffer size.
> + * @verbose: verbose flag.
> + *
> + * Based on the documentations TCG Storage Opal SSC 2.01 chapter 3.3.3 a=
nd
> + * NVM ExpressTM Revision 1.4c, chapter 5.25,
> + * read security receive command via ioctl().
> + * On success, @response_buffer is completed.
> + *
> + * Return: %MDADM_STATUS_SUCCESS on success, %MDADM_STATUS_ERROR otherwi=
se.
> + */
> +static mdadm_status_t
> +nvme_security_recv_ioctl(int disk_fd, __u8 sec_protocol, __u16 comm_id, =
void *response_buffer,
> +                        size_t buf_size, const int verbose)
> +{
> +       struct nvme_admin_cmd nvme_cmd =3D {0};
> +       int status;
> +
> +       nvme_cmd.opcode =3D NVME_SECURITY_RECV;
> +       nvme_cmd.cdw10 =3D sec_protocol << 24 | comm_id << 8;
> +       nvme_cmd.cdw11 =3D buf_size;
> +       nvme_cmd.data_len =3D buf_size;
> +       nvme_cmd.addr =3D (__u64)response_buffer;

Hi all

In i686 platform, it reports error:

drive_encryption.c: In function =E2=80=98nvme_security_recv_ioctl=E2=80=99:
drive_encryption.c:236:25: error: cast from pointer to integer of
different size [-Werror=3Dpointer-to-int-cast]
  236 |         nvme_cmd.addr =3D (__u64)response_buffer;
      |                         ^
drive_encryption.c: In function =E2=80=98nvme_identify_ioctl=E2=80=99:
drive_encryption.c:271:25: error: cast from pointer to integer of
different size [-Werror=3Dpointer-to-int-cast]
  271 |         nvme_cmd.addr =3D (__u64)response_buffer;
      |                         ^
cc1: all warnings being treated as errors
make: *** [Makefile:211: drive_encryption.o] Error 1

The pointer should be 32bit and it tries to convert to 64 bit.

Best Regards
Xiao

> +
> +       status =3D ioctl(disk_fd, NVME_IOCTL_ADMIN_CMD, &nvme_cmd);
> +       if (status !=3D 0) {
> +               pr_vrb("Failed to read NVMe security receive ioctl() for =
device /dev/%s, status: %d\n",
> +                      fd2kname(disk_fd), status);
> +               return MDADM_STATUS_ERROR;
> +       }
> +
> +       return MDADM_STATUS_SUCCESS;
> +}
> +
> +/**
> + * nvme_identify_ioctl() - NVMe identify ioctl.
> + * @disk_fd: a disk file descriptor.
> + * @response_buffer: response buffer to fill out.
> + * @buf_size: response buffer size.
> + * @verbose: verbose flag.
> + *
> + * Based on the documentations TCG Storage Opal SSC 2.01 chapter 3.3.3 a=
nd
> + * NVM ExpressTM Revision 1.4c, chapter 5.25,
> + * read NVMe identify via ioctl().
> + * On success, @response_buffer will be completed.
> + *
> + * Return: %MDADM_STATUS_SUCCESS on success, %MDADM_STATUS_ERROR otherwi=
se.
> + */
> +static mdadm_status_t
> +nvme_identify_ioctl(int disk_fd, void *response_buffer, size_t buf_size,=
 const int verbose)
> +{
> +       struct nvme_admin_cmd nvme_cmd =3D {0};
> +       int status;
> +
> +       nvme_cmd.opcode =3D NVME_IDENTIFY;
> +       nvme_cmd.cdw10 =3D NVME_IDENTIFY_CONTROLLER_DATA;
> +       nvme_cmd.data_len =3D buf_size;
> +       nvme_cmd.addr =3D (__u64)response_buffer;
> +
> +       status =3D ioctl(disk_fd, NVME_IOCTL_ADMIN_CMD, &nvme_cmd);
> +       if (status !=3D 0) {
> +               pr_vrb("Failed to read NVMe identify ioctl() for device /=
dev/%s, status: %d\n",
> +                      fd2kname(disk_fd), status);
> +               return MDADM_STATUS_ERROR;
> +       }
> +
> +       return MDADM_STATUS_SUCCESS;
> +}
> +
> +/**
> + * is_sec_prot_01h_supported() - check if security protocol 01h supporte=
d.
> + * @security_protocols: struct with response from disk (NVMe, SATA) desc=
ribing supported
> + * security protocols.
> + *
> + * Return: true if TCG_SECP_01 found, false otherwise.
> + */
> +static bool is_sec_prot_01h_supported(supported_security_protocols_t *se=
curity_protocols)
> +{
> +       int list_length =3D be16toh(security_protocols->list_length);
> +       int index;
> +
> +       for (index =3D 0 ; index < list_length; index++) {
> +               if (security_protocols->list[index] =3D=3D TCG_SECP_01)
> +                       return true;
> +       }
> +
> +       return false;
> +}
> +
> +/**
> + * is_sec_prot_01h_supported_nvme() - check if security protocol 01h sup=
ported for given NVMe disk.
> + * @disk_fd: a disk file descriptor.
> + * @verbose: verbose flag.
> + *
> + * Return: %DRIVE_FEAT_SUP_ST if TCG_SECP_01 supported, %DRIVE_FEAT_NOT_=
SUP_ST if not supported,
> + * %DRIVE_FEAT_CHECK_FAILED_ST if failed to check.
> + */
> +static drive_feat_sup_st is_sec_prot_01h_supported_nvme(int disk_fd, con=
st int verbose)
> +{
> +       supported_security_protocols_t security_protocols =3D {0};
> +
> +       /* security_protocol: TCG_SECP_00, comm_id: not applicable */
> +       if (nvme_security_recv_ioctl(disk_fd, TCG_SECP_00, 0x0, &security=
_protocols,
> +                                    sizeof(security_protocols), verbose)=
)
> +               return DRIVE_FEAT_CHECK_FAILED_ST;
> +
> +       if (is_sec_prot_01h_supported(&security_protocols))
> +               return DRIVE_FEAT_SUP_ST;
> +
> +       return DRIVE_FEAT_NOT_SUP_ST;
> +}
> +
> +/**
> + * is_nvme_sec_send_recv_supported() - check if Security Send and Securi=
ty Receive is supported.
> + * @disk_fd: a disk file descriptor.
> + * @verbose: verbose flag.
> + *
> + * Check if "Optional Admin Command Support" bit 0 is set in NVMe identi=
fy.
> + * Bit 0 set to 1 means controller supports the Security Send and Securi=
ty Receive commands.
> + *
> + * Return: %DRIVE_FEAT_SUP_ST if security send/receive supported,
> + * %DRIVE_FEAT_NOT_SUP_ST if not supported, %DRIVE_FEAT_CHECK_FAILED_ST =
if check failed.
> + */
> +static drive_feat_sup_st is_nvme_sec_send_recv_supported(int disk_fd, co=
nst int verbose)
> +{
> +       nvme_identify_ctrl_t nvme_identify =3D {0};
> +       int status =3D 0;
> +
> +       status =3D nvme_identify_ioctl(disk_fd, &nvme_identify, sizeof(nv=
me_identify), verbose);
> +       if (status)
> +               return DRIVE_FEAT_CHECK_FAILED_ST;
> +
> +       if ((__le16_to_cpu(nvme_identify.oacs) & 0x1) =3D=3D 0x1)
> +               return DRIVE_FEAT_SUP_ST;
> +
> +       return DRIVE_FEAT_NOT_SUP_ST;
> +}
> +
> +/**
> + * get_opal_encryption_information() - get Opal encryption information.
> + * @buffer: buffer with Opal Level 0 Discovery response.
> + * @information: struct to fill out, describing encryption status of dis=
k.
> + *
> + * If Locking feature frame is in response from Opal Level 0 discovery, =
&encryption_information_t
> + * structure is completed with status and ability otherwise the status i=
s set to &None.
> + * For possible encryption statuses and abilities,
> + * please refer to enums &encryption_status and &encryption_ability.
> + *
> + * Return: %MDADM_STATUS_SUCCESS on success, %MDADM_STATUS_ERROR otherwi=
se.
> + */
> +static mdadm_status_t get_opal_encryption_information(__u8 *buffer,
> +                                                     encryption_informat=
ion_t *information)
> +{
> +       opal_locking_feature_t *opal_locking_feature =3D
> +                                       get_opal_locking_feature_descript=
ion(buffer);
> +
> +       if (!opal_locking_feature)
> +               return MDADM_STATUS_ERROR;
> +
> +       if (opal_locking_feature->locking_supported =3D=3D 1) {
> +               information->ability =3D ENC_ABILITY_SED;
> +
> +               if (opal_locking_feature->locking_enabled =3D=3D 0)
> +                       information->status =3D ENC_STATUS_UNENCRYPTED;
> +               else if (opal_locking_feature->locked =3D=3D 1)
> +                       information->status =3D ENC_STATUS_LOCKED;
> +               else
> +                       information->status =3D ENC_STATUS_UNLOCKED;
> +       } else {
> +               information->ability =3D ENC_ABILITY_NONE;
> +               information->status =3D ENC_STATUS_UNENCRYPTED;
> +       }
> +
> +       return MDADM_STATUS_SUCCESS;
> +}
> +
> +/**
> + * get_nvme_opal_encryption_information() - get NVMe Opal encryption inf=
ormation.
> + * @disk_fd: a disk file descriptor.
> + * @information: struct to fill out, describing encryption status of dis=
k.
> + * @verbose: verbose flag.
> + *
> + * In case the disk supports Opal Level 0 discovery, &encryption_informa=
tion_t structure
> + * is completed with status and ability based on ioctl response,
> + * otherwise the ability is set to %ENC_ABILITY_NONE and &status to %ENC=
_STATUS_UNENCRYPTED.
> + * As the current use case does not need the knowledge of Opal support, =
if there is no support,
> + * %MDADM_STATUS_SUCCESS will be returned, with the values described abo=
ve.
> + * For possible encryption statuses and abilities,
> + * please refer to enums &encryption_status and &encryption_ability.
> + *
> + * %MDADM_STATUS_SUCCESS on success, %MDADM_STATUS_ERROR otherwise.
> + */
> +mdadm_status_t
> +get_nvme_opal_encryption_information(int disk_fd, encryption_information=
_t *information,
> +                                    const int verbose)
> +{
> +       __u8 buffer[OPAL_IO_BUFFER_LEN];
> +       int sec_send_recv_supported =3D 0;
> +       int protocol_01h_supported =3D 0;
> +       mdadm_status_t status;
> +
> +       information->ability =3D ENC_ABILITY_NONE;
> +       information->status =3D ENC_STATUS_UNENCRYPTED;
> +
> +       sec_send_recv_supported =3D is_nvme_sec_send_recv_supported(disk_=
fd, verbose);
> +       if (sec_send_recv_supported =3D=3D DRIVE_FEAT_CHECK_FAILED_ST)
> +               return MDADM_STATUS_ERROR;
> +
> +       /* Opal not supported */
> +       if (sec_send_recv_supported =3D=3D DRIVE_FEAT_NOT_SUP_ST)
> +               return MDADM_STATUS_SUCCESS;
> +
> +       /**
> +        * sec_send_recv_supported determine that it should be possible t=
o read
> +        * supported sec protocols
> +        */
> +       protocol_01h_supported =3D is_sec_prot_01h_supported_nvme(disk_fd=
, verbose);
> +       if (protocol_01h_supported =3D=3D DRIVE_FEAT_CHECK_FAILED_ST)
> +               return MDADM_STATUS_ERROR;
> +
> +       /* Opal not supported */
> +       if (sec_send_recv_supported =3D=3D DRIVE_FEAT_SUP_ST &&
> +           protocol_01h_supported =3D=3D DRIVE_FEAT_NOT_SUP_ST)
> +               return MDADM_STATUS_SUCCESS;
> +
> +       if (nvme_security_recv_ioctl(disk_fd, TCG_SECP_01, OPAL_DISCOVERY=
_COMID, (void *)&buffer,
> +                                    OPAL_IO_BUFFER_LEN, verbose))
> +               return MDADM_STATUS_ERROR;
> +
> +       status =3D get_opal_encryption_information((__u8 *)&buffer, infor=
mation);
> +       if (status)
> +               pr_vrb("Locking feature description not found in Level 0 =
discovery response. Device /dev/%s.\n",
> +                      fd2kname(disk_fd));
> +
> +       if (information->ability =3D=3D ENC_ABILITY_NONE)
> +               assert(information->status =3D=3D ENC_STATUS_UNENCRYPTED)=
;
> +
> +       return status;
> +}
> diff --git a/drive_encryption.h b/drive_encryption.h
> new file mode 100644
> index 00000000..82c2c624
> --- /dev/null
> +++ b/drive_encryption.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Read encryption information for Opal and ATA devices.
> + *
> + * Copyright (C) 2024 Intel Corporation
> + *     Author: Blazej Kucman <blazej.kucman@intel.com>
> + */
> +
> +typedef enum encryption_status {
> +       /* The drive is not currently encrypted. */
> +       ENC_STATUS_UNENCRYPTED =3D 0,
> +       /* The drive is encrypted and the data is not accessible. */
> +       ENC_STATUS_LOCKED,
> +       /* The drive is encrypted but the data is accessible in unencrypt=
ed form. */
> +       ENC_STATUS_UNLOCKED
> +} encryption_status_t;
> +
> +typedef enum encryption_ability {
> +       ENC_ABILITY_NONE =3D 0,
> +       ENC_ABILITY_OTHER,
> +       /* Self encrypted drive */
> +       ENC_ABILITY_SED
> +} encryption_ability_t;
> +
> +typedef struct encryption_information {
> +       encryption_ability_t ability;
> +       encryption_status_t status;
> +} encryption_information_t;
> +
> +mdadm_status_t
> +get_nvme_opal_encryption_information(int disk_fd, struct encryption_info=
rmation *information,
> +                                    const int verbose);
> --
> 2.35.3
>
>

