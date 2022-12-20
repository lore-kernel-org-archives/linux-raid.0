Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C68CC4332F
	for <linux-raid@archiver.kernel.org>; Tue, 20 Dec 2022 10:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiLTKq4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Dec 2022 05:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbiLTKqw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Dec 2022 05:46:52 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23556B5E
        for <linux-raid@vger.kernel.org>; Tue, 20 Dec 2022 02:46:51 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 121FD61CCD7B0;
        Tue, 20 Dec 2022 11:46:48 +0100 (CET)
Message-ID: <0ff7aa1b-b1c9-2f1a-354c-9ee2696ec480@molgen.mpg.de>
Date:   Tue, 20 Dec 2022 11:46:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] incremental, manage: do not verify if remove is safe
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org, colyli@suse.de,
        xni@redhat.com
References: <20221220032151.12067-1-kinga.tanska@intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20221220032151.12067-1-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Kinga,


Thank you for your patch.

Am 20.12.22 um 04:21 schrieb Kinga Tanska:

[…]

> +/**
> + * Manage_subdevs() - Execute operation depending on devmode.
> + *
> + * @devname: name of the device.
> + * @fd: file descriptor.
> + * @devlist: list of sub-devices to manage.
> + * @verbose: verbose level.
> + * @test: test flag.
> + * @update: type of update.
> + * @force: force flag.
> + *
> + * This function executes operation defined by devmode
> + * for each dev from devlist.
> + * Devmode can be:
> + * 'a' - add the device
> + * 'S' - add the device as a spare - don't try re-add
> + * 'j' - add the device as a journal device
> + * 'A' - re-add the device
> + * 'r' - remove the device: HOT_REMOVE_DISK
> + *       device can be 'faulty' or 'detached' in which case all
> + *       matching devices are removed.
> + * 'f' - set the device faulty SET_DISK_FAULTY
> + *       device can be 'detached' in which case any device that
> + *       is inaccessible will be marked faulty.
> + * 'I' - remove device by using incremental fail
> + *       which is executed when device is removed surprisingly.
> + * 'R' - mark this device as wanting replacement.
> + * 'W' - this device is added if necessary and activated as
> + *       a replacement for a previous 'R' device.
> + * -----
> + * 'w' - 'W' will be changed to 'w' when it is paired with
> + *       a 'R' device.  If a 'W' is found while walking the list
> + *       it must be unpaired, and is an error.
> + * 'M' - this is created by a 'missing' target.  It is a slight
> + *       variant on 'A'
> + * 'F' - Another variant of 'A', where the device was faulty
> + *       so must be removed from the array first.
> + * 'c' - confirm the device as found (for clustered environments)
> + *
> + * For 'f' and 'r', the device can also be a kernel-internal
> + * name such as 'sdb'.
> + *
> + * Return: 0 on success, otherwise 1 or 2.
> + */
>   int Manage_subdevs(char *devname, int fd,
>   		   struct mddev_dev *devlist, int verbose, int test,
>   		   char *update, int force)
>   {
> -	/* Do something to each dev.
> -	 * devmode can be
> -	 *  'a' - add the device
> -	 *  'S' - add the device as a spare - don't try re-add
> -	 *  'j' - add the device as a journal device
> -	 *  'A' - re-add the device
> -	 *  'r' - remove the device: HOT_REMOVE_DISK
> -	 *        device can be 'faulty' or 'detached' in which case all
> -	 *	  matching devices are removed.
> -	 *  'f' - set the device faulty SET_DISK_FAULTY
> -	 *        device can be 'detached' in which case any device that
> -	 *	  is inaccessible will be marked faulty.
> -	 *  'R' - mark this device as wanting replacement.
> -	 *  'W' - this device is added if necessary and activated as
> -	 *        a replacement for a previous 'R' device.
> -	 * -----
> -	 *  'w' - 'W' will be changed to 'w' when it is paired with
> -	 *        a 'R' device.  If a 'W' is found while walking the list
> -	 *        it must be unpaired, and is an error.
> -	 *  'M' - this is created by a 'missing' target.  It is a slight
> -	 *        variant on 'A'
> -	 *  'F' - Another variant of 'A', where the device was faulty
> -	 *        so must be removed from the array first.
> -	 *  'c' - confirm the device as found (for clustered environments)
> -	 *
> -	 * For 'f' and 'r', the device can also be a kernel-internal
> -	 * name such as 'sdb'.
> -	 */

Please move the comment in a separate commit.


Kind regards,

Paul
