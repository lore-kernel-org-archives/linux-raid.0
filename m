From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] drivers/md.c: Make bio_alloc_mddev return
 bio_alloc_bioset
Date: Mon, 14 Jan 2019 09:39:41 +0100
Message-ID: <88ac62d2-3f31-fbe4-4463-ff9d23b5e200@intel.com>
References: <20181222100845.566772-1-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181222100845.566772-1-marcos.souza.org@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>, linux-kernel@vger.kernel.org
Cc: shli@kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/22/18 11:08 AM, Marcos Paulo de Souza wrote:
> bio_alloc_bioset return a bio pointer or NULL, so we can avoid storing
> the returned data into a new variable.
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>

Acked-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
