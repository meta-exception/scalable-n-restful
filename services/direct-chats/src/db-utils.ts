
function createConfigs(n: number) {
  const configs = [];
  for (let i = 0; i < n; i++) {
    const config = {
      user: 'postgres',
      host: `10.2.0.${i + 2}`,
      database: 'postgres',
      password: 'ALLBADTHINGS',
      port: 5432,
    };
    configs.push(config);
  }
  return configs;
}

export default createConfigs;
