Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7973047F4A
	for <linux-raid@vger.kernel.org>; Mon,  8 Apr 2024 09:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712568679; cv=none; b=WjIwgh08MCSc+SYXtAbJmoFpTd+YDVc+x6JFbgJVOY3sClYf+VKaOXWlAeJqDJ0y2su6OHxbYFFiTSWSjHeerpVU5VI+JmZjVJYw7b+VfsSpxMv8ykgl1HVvFv1t49dfwkccN+vp6Qsm02xNiy2aQSbs12MQYw4i8mW6I+6ke60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712568679; c=relaxed/simple;
	bh=+0/FSx0BWFfrhChqofN99lJVIV/55sAFWgbva52s+gQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=L+FMrdve0FyyD8BPjblii0Kc4qEt5heMd3ab8YfrpMGotko1dJumqKsKKTVIM5++ZkiAhHGu+rifLEy4prlvnxQPMMPcgKGuQvz7fB0zXYoIfaetunUPqITO0FYwr9JvVvwXkoSbXketqEnu+vdm5S+J51m4pypaUqabiJX4ZBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QUG/fD+X; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QUG/fD+X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712568679; x=1744104679;
  h=date:from:to:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=+0/FSx0BWFfrhChqofN99lJVIV/55sAFWgbva52s+gQ=;
  b=QUG/fD+XB0EoBjthEbOLG9sTMqYWs7olyVA8Atc6aFbpPvW2rGQZeQS8
   LxSktG1AKFviI1HqoTmtFeRS9TZge/+3O58zg1OitwQ6iUKm0O7oUAG58
   5aPWAK+KoKR+dfa9BfnFxUuF7KWF6o9YSXcr6RU38Dt3LMLH5fm9CMbu2
   Se/tQcp8OZCqIb3fvzpqKsx5yK9P2Ldk5NLQ7UEKKzFqRXZl3j/ODcprt
   eq460fEB8u9Eu2j2BPQk4FyxRIBSHv+D1KGwsEoP7rhqdSlN7f+f2PXBP
   28CqB9hXNcu4kjrXgk7e9JeE31KYoTmCJjL/qsDDnEUdOrOpFX22Schc4
   g==;
X-CSE-ConnectionGUID: PE6MFUKNTuqZl+wprYi+GQ==
X-CSE-MsgGUID: 3YRKGDKYRTO1nbyUei7NLA==
X-IronPort-AV: E=McAfee;i="6600,9927,11037"; a="11610777"
X-IronPort-AV: E=Sophos;i="6.07,186,1708416000"; 
   d="scan'208";a="11610777"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 02:31:18 -0700
X-CSE-ConnectionGUID: AeBGEKHdToWqjf7p4C/c/w==
X-CSE-MsgGUID: eS2hJXyFQZySO0xrXePCxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,186,1708416000"; 
   d="scan'208";a="24568466"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.1.223])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 02:31:16 -0700
Date: Mon, 8 Apr 2024 11:31:11 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Subject: mdadm: Introducing main branch
Message-ID: <20240408113111.00000b45@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello,
Just a notification, I created main branch which will follow master for now.
In the future I would like to replace master with main as a primary branch.

The motivation is to follow non-divisive language.

Thanks,
Mariusz
