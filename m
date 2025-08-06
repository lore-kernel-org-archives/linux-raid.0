Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57612BD580;
	Wed,  6 Aug 2025 17:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754500529; cv=none; b=ZgafdR9NftJggMy9Nyl9zrvXPRM41JC2wdKw/fxOOTyHELqc65OPBEwPXN/OVHxGDtwjgtPknj5pRl+t3xW6Etn2CQchTjwrW+o7Pj07axxNGszfNWP6PAtpFcIjr06BSDgr+C4PnE9oNVfz65nRFAHvAP9ZR5VWd0cO2vkfp8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754500529; c=relaxed/simple;
	bh=8B0NliE6n4LX04m96CKEoounFlBMNv1G5wfUZ2Px2js=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=O9l6vn4KijzXT1njW0QL2ooOqhpPVy8OBciZWN4fGg7EqyDeL5OtyuDOHK++XOxs8W90wP6SQvmPhwdwBDBOGwjSZSpdUGfoRwvuoccYbU/QCs1PaigsmNOJFrHKkVjFzZrrPv5MjUm6ASlGOeYeleelCpmBlxoE7Wx76kpnlXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtfGF0JX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtfGF0JX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7EFC4CEF7;
	Wed,  6 Aug 2025 17:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754500529;
	bh=8B0NliE6n4LX04m96CKEoounFlBMNv1G5wfUZ2Px2js=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=dtfGF0JXvAFud8q/t+UzlW9sRz3VRGJF87Qexg5vE4OaYMrJb2B715zgsV1A+Tk/5
	 LBOLkfZLw/tv/rNIRNbDpiRqqXhkLjV0wMOPwUj+/09DvhKSmD07mEkaJmJOlUSllu
	 NpsfTmECkgqyNxtezLWWdhtJv63DDOdSdsxdIcW2x6mQP5swa0xi6in0VLUV9Q7EGl
	 nguYPEePZ/YujzBUT5O5hKBsrCK0dAc/NmHdguzZnuC+hGA4VfivNa2FtOc/5+F5OP
	 FTUjvKqSRjcewEoFk7jTFWmDpmIatyVCt7ETPBLkMl3s7tFJKz3fj+ka130OmPEjaw
	 DZlVrU44YrbzA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADE0F383BF63;
	Wed,  6 Aug 2025 17:15:44 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3 0/5] Add an optimization also raid6test for RISC-V
 support
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <175450054334.2863135.1157154910946265186.git-patchwork-notify@kernel.org>
Date: Wed, 06 Aug 2025 17:15:43 +0000
References: <20250718072711.3865118-1-zhangchunyan@iscas.ac.cn>
In-Reply-To: <20250718072711.3865118-1-zhangchunyan@iscas.ac.cn>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Cc: linux-riscv@lists.infradead.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 charlie@rivosinc.com, song@kernel.org, yukuai3@huawei.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 zhang.lyra@gmail.com

Hello:

This series was applied to riscv/linux.git (for-next)
by Alexandre Ghiti <alexghiti@rivosinc.com>:

On Fri, 18 Jul 2025 15:27:06 +0800 you wrote:
> The 1st patch is a cleanup;
> Patch 2/4 is an optimization that takes Palmer's suggestion;
> The last two patches add raid6test support and make the raid6 RVV code buildable on user space.
> 
> V3:
> - Rephrased the commit message of patch 3;
> - Added Alex's Reviewed-by on patch 1-2;
> 
> [...]

Here is the summary with links:
  - [V3,1/5] raid6: riscv: Clean up unused header file inclusion
    https://git.kernel.org/riscv/c/37b36d582c02
  - [V3,2/5] raid6: riscv: replace one load with a move to speed up the caculation
    https://git.kernel.org/riscv/c/ae1e25a17cee
  - [V3,3/5] raid6: riscv: Prevent compiler with vector support to build already vectorized code
    https://git.kernel.org/riscv/c/eda46027e4b6
  - [V3,4/5] raid6: riscv: Allow code to be compiled in userspace
    https://git.kernel.org/riscv/c/e3493fde9c22
  - [V3,5/5] raid6: test: Add support for RISC-V
    https://git.kernel.org/riscv/c/db001a4e2eca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


